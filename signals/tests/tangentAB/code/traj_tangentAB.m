function paths = traj_tangentAB(A, B, theta_0, v_0, v_01, v_1, alpha_0, alpha_1)
    if((alpha_1 > 0) && (alpha_0 > 0) && (alpha_0 + alpha_1 > 1))
        error('alpha_0 and alpha_1 must sum 1 and be greater than 0');
    end
    
    % Distance between path points
    BA = B - A;
    dAB = norm(BA);
    
    % Circle radius
    r0 = alpha_0*dAB;
    r1 = alpha_1*dAB;

    % Angular velocity through path
    omega_0 = v_0/r0;
    omega_1 = v_1/r1;
    
    paths = calculate_paths(A, B, v_0, v_01, v_1, alpha_0, alpha_1, theta_0);
    paths = feasible_paths(paths, A, B, r0, r1, v_0, v_01, v_1, theta_0);
    
    for i = 1:length(paths)
        path = paths{i};
        path.traj_diff = @(t, nd_deriv) nd_tangentAB(t, path, nd_deriv);
    end
    
    for i = 1:length(paths) 
        paths{i}.traj_diff = @(t, nd_deriv) nd_tangentAB(t, paths{i}, nd_deriv);
    end
    
    dABs = [];
    for i = 1:length(paths_)
        path = paths_{i};
        dAB = path.arg0*path.r0 + path.dCD + path.arg1*path.r1;
        dABs = [dABs; dAB];
    end
    
    [~, idx] = min(dABs);
    paths = {paths_{idx}};
end

function paths = feasible_paths(paths, A, B, r0, r1, v_0, v_01, v_1, theta_0)
    EPS_ = 1e-3;
    
    % Orientations
    BA = B - A;
    theta_1 = atan2(BA(2), BA(1));
    
    % sigma = 0.1;
    % theta_1 = theta_1 + gaussianrnd(0, sigma);
    
    omega_0 = v_0/r0;
    omega_1 = v_1/r1;
    
    % Centers of circles
    rhat0 = [cos(theta_0); sin(theta_0)];
    rhat1 = [cos(theta_1); sin(theta_1)];
    
    for i = 1:length(paths)
        path = paths{i};

        paths_to_goal = []; 
        
        % Possibilities 
        %     - A-C0, D1-B
        %     - A-C1, D0-B
        for j = 1:2
            switch j
                % First path
                case 1
                    orig_0 = A;
                    dest_0 = path.C_0;
                    center_0 = path.center_0;
                    phi_0 = path.phi_0;
                                        
                    orig_1 = B;
                    dest_1 = path.D_1;
                    center_1 = path.center_1;
                    phi_1 = path.phi_1;
                
                % Second path
                case 2
                    orig_0 = A;
                    dest_0 = path.C_1;
                    center_0 = path.center_0;
                    phi_0 = path.phi_0;

                    orig_1 = B;
                    dest_1 = path.D_0;
                    center_1 = path.center_1;
                    phi_1 = path.phi_1;
            end

            % Angle between origin and destiny
            orig_center_0 = orig_0 - center_0;
            dest_center_0 = dest_0 - center_0;
            orig_center_1 = orig_1 - center_1;
            dest_center_1 = dest_1 - center_1;

            arg_od_0 = arguv(orig_center_0, dest_center_0);
            arg_od_1 = arguv(orig_center_1, dest_center_1);

            args_od_0 = [arg_od_0; 2*pi - arg_od_0];
            args_od_1 = [arg_od_1; 2*pi - arg_od_1];
            
            for m = 1:length(args_od_0)
                for n = 1:length(args_od_1)
                    arg_od_0 = args_od_0(m);
                    arg_od_1 = args_od_1(n);
                    
                    % Minus and plus solution
                    vec_0_begin = [-sin(phi_0); cos(phi_0)];
                    vec_1_begin = -[-sin(phi_1); cos(phi_1)];

                    sign_0 = dot(vec_0_begin, rhat0);
                    sign_1 = dot(vec_1_begin, rhat1);

                    % Connector line orientation
                    norm_CD = norm(dest_1 - dest_0);
                    CD_hat = (dest_1 - dest_0)/norm_CD;

                    % Position constraint
                    t_0 = arg_od_0/omega_0;
                    t_01 = norm_CD/v_01;
                    t_1 = arg_od_1/omega_1;
                    
                    vec_0_end = [cos(sign_0*arg_od_0 + phi_0); ...
                                 sin(sign_0*arg_od_0 + phi_0)];
                    vec_1_end = [cos(sign_1*arg_od_1 + phi_1); ...
                                 sin(sign_1*arg_od_1 + phi_1)];

                    dest_0_ = r0*vec_0_end + center_0;
                    dest_1_ = r1*vec_1_end + center_1;

                    orient_0_orig = sign_0*[-sin(phi_0); cos(phi_0)];
                    orient_1_orig = sign_1*[-sin(phi_1); cos(phi_1)];

                    orient_0_dest = sign_0*[-sin(sign_0*arg_od_0 + phi_0); ...
                                             cos(sign_0*arg_od_0 + phi_0)];
                    orient_1_dest = sign_1*[-sin(sign_1*arg_od_1 + phi_1); ...
                                             cos(sign_1*arg_od_1 + phi_1)];

                    pos_cond0 = norm(dest_0_ - dest_0) < EPS_;
                    pos_cond1 = norm(dest_1_ - dest_1) < EPS_;
                    CD_cond0 = abs(dot(orient_0_dest, CD_hat) - 1) < EPS_;
                    CD_cond1 = abs(dot(orient_1_dest, CD_hat) + 1) < EPS_;

                    if(CD_cond1 && pos_cond1)
                        orient_1 = sign_1*[-sin(sign_1*arg_od_1 + phi_1); ...
                                            cos(sign_1*arg_od_1 + phi_1)];
                        orient_B = sign_1*[-sin(phi_1); cos(phi_1)];

                        if(CD_cond0 && pos_cond0)
                            
                            % First circle
                            path_0 = [];
                            dt = 1e-3;
                            nt_0 = floor(t_0/dt);
                            t0 = [(0:dt:nt_0*dt)'; t_0];

                            for k = 1:length(t0)
                                vec_0 = [cos(sign_0*omega_0*t0(k) + phi_0); ...
                                         sin(sign_0*omega_0*t0(k) + phi_0)];
                                pos_0 = r0*vec_0 + center_0;

                                path_0 = [path_0; pos_0'];
                            end

                            % Intermediate line
                            path_1 = [];
                            n_t1 = floor(t_1/dt);
                            t1 = [(dt:dt:n_t1*dt)'; t_1];

                            for k = 1:length(t1)
                                vec_1 = [cos(sign_1*omega_1*t1(k) + phi_1); ...
                                         sin(sign_1*omega_1*t1(k) + phi_1)];
                                pos_1 = r1*vec_1 + center_1;

                                path_1 = [path_1; pos_1'];
                            end
                            
                            path_1 = flipud(path_1);

                            % Second circle
                            path_01 = [];
                            d01 = norm(dest_1 - dest_0);

                            t_01 = d01/v_01;
                            nt_01 = floor(t_01/dt);
                            t01 = [(dt:dt:nt_01*dt)'; t_01];

                            for j = 1:length(t01)
                                P_i = dest_0 + (t01(j)/t_01)*(dest_1 - dest_0);
                                path_01 = [path_01; P_i'];
                            end
                            
                            path_to_goal = {path_0; path_01; path_1};
                            t_traj = {t0; t_0 + t01; t_0 + t_01 + t1};
                            
                            paths{i}.t_traj = t_traj;
                            paths{i}.trajectory = path_to_goal;
                            
                            paths{i}.sign_0 = sign_0;
                            paths{i}.sign_1 = sign_1;
                            
                            paths{i}.dest_0 = dest_0;
                            paths{i}.orig_1 = dest_1;

                            paths{i}.t_0 = t_0;
                            paths{i}.t_01 = t_01;
                            paths{i}.t_1 = t_1;

                            paths{i}.arg0 = arg_od_0;
                            paths{i}.dCD = norm_CD;
                            paths{i}.arg1 = arg_od_1;

                        end
                    end 
                end
            end
        end
    end
    
    paths_ = {};
    for i = 1:length(paths)
        path = paths{i};
        
        if(~isempty(path.trajectory))
            paths_{end+1} = path;
        end
    end
    
    paths = paths_;
end

function paths = calculate_paths(A, B, v_0, v_01, v_1, alpha_0, alpha_1, theta_0)
    % Distance between path points
    BA = B - A;
    dAB = norm(BA);

    % Circle radius
    r0 = alpha_0*dAB;
    r1 = alpha_1*dAB;

    % Angular velocity through path
    omega_0 = v_0/r0;
    omega_1 = v_1/r1;
    
    % Orientations
    theta_1 = atan2(BA(2), BA(1));
    
    % Centers of circles
    rhat0 = [cos(theta_0); sin(theta_0)];
    rhat1 = [cos(theta_1); sin(theta_1)];

    signs = [-1 1];
    paths = {};

    for signA = signs
        for signB = signs
            phi_0 = my_atan2(-rhat0(1), rhat0(2));
            phi_1 = my_atan2(-rhat1(1), rhat1(2));
            
            rhat0_perp = [cos(phi_0); sin(phi_0)];
            rhat1_perp = [cos(phi_1); sin(phi_1)];

            center_0 = A + signA*r0*rhat0_perp;
            center_1 = B + signB*r1*rhat1_perp;

            A_ = r0*[cos(phi_0); sin(phi_0)] + center_0;
            B_ = r1*[cos(phi_1); sin(phi_1)] + center_1;

            % A is equal to A_
            if(~all(~(A_ == A)))
            else
                phi_0 = -pi + phi_0;
            end

            % B is equal to B_
            if(~all(~(B_ == B)))
            else
                phi_1 = -pi + phi_1;
            end

            A_ = r0*[cos(phi_0); sin(phi_0)] + center_0;
            B_ = r1*[cos(phi_1); sin(phi_1)] + center_1;

            if(norm(center_1 - center_0) > r0 + r1)
                [C_0, C_1, D_0, D_1, ...
                 ~, line0, line1] = inner_tangentAB(center_0, center_1, r0, r1);

                dtheta = 0.01;
                thetas = 0:dtheta:2*pi;

                circA = [];
                circB = [];
                for theta = thetas
                    circ0_i = r0*[cos(theta); sin(theta)] + center_0;
                    circ1_i = r1*[cos(theta); sin(theta)] + center_1;

                    circA = [circA; circ0_i'];
                    circB = [circB; circ1_i'];
                end

                fields = {'circA', 'circB', 'center_0', 'center_1', ...
                          'phi_0', 'phi_1', 'r0', 'r1', 'omega_0', 'omega_1', ...
                          'sign_0', 'sign_1', 'A', 'B', 'C_0', 'C_1', 'D_0', 'D_1', ...
                          'trajectory', 't_traj', 'dest_0', 'orig_1', ...
                          'line0', 'line1', 't_0', 't_01', 't_1', ...
                          'arg0', 'dCD', 'arg1', ...
                          'v_0', 'v_01', 'v_1', 'traj_diff'};
                values = {circA , circB, ...
                          center_0, center_1, ...
                          phi_0, phi_1, r0, r1, omega_0, omega_1, ...
                          1, 1, A, B, C_0, C_1, D_0, D_1, ...
                          {}, {}, [], [], ...
                          line0, line1, 0, 0, 0, ...
                          0, 0, 0, ...
                          v_0, v_01, v_1, 0};
                      
                path_i = cell2struct(values, fields, 2);
                paths{end+1} = path_i;
            end
        end
    end
end

function traj_ = nd_tangentAB(t, path, nd_traj)
    if(nd_traj < 1)
        error('Derivative must be greater or equal to 1!');
    end
    
    t_0  = path.t_0;
    t_01 = path.t_01;
    t_1  = path.t_1;
    
    r0 = path.r0;
    r1 = path.r1;
    
    phi_0 = path.phi_0;
    phi_1 = path.phi_1;
    
    omega_0 = path.omega_0;
    omega_1 = path.omega_1;
    
    sign_0 = path.sign_0;
    sign_1 = path.sign_1;
    
    EPS_ = 1e-3;
    if((t >= 0) && (t < t_0))
        vecs_0 = {};
        vecs_0{1} = [cos(sign_0*omega_0*t + phi_0); 
                     sin(sign_0*omega_0*t + phi_0)];
        vecs_0{2} = [-sin(sign_0*omega_0*t + phi_0); 
                     cos(sign_0*omega_0*t + phi_0)];
        vecs_0{3} = [-cos(sign_0*omega_0*t + phi_0); 
                     -sin(sign_0*omega_0*t + phi_0)];
        vecs_0{4} = [sin(sign_0*omega_0*t + phi_0); 
                     -cos(sign_0*omega_0*t + phi_0)];

        idx = mod(nd_traj, 4) + 1;

        traj_ = r0*((sign_0*omega_0)^nd_traj)*vecs_0{idx};

    elseif((t >= t_0) && (t < t_0 + t_01))
        if(nd_traj == 1)
            traj_ = (path.orig_1 - path.dest_0)/t_01;
        else
            traj_ = zeros(size(path.orig_1));
        end
        
    elseif((t >= t_0 + t_01) && (t <= (1 + EPS_)*(t_0 + t_01 + t_1)))
        vecs_1 = {};
        vecs_1{1} = [cos(sign_1*omega_1*(t_0 + t_01 + t_1 - t) + phi_1);
                     sin(sign_1*omega_1*(t_0 + t_01 + t_1- t) + phi_1)];
        vecs_1{2} = [-sin(sign_1*omega_1*(t_0 + t_01 + t_1- t) + phi_1);
                      cos(sign_1*omega_1*(t_0 + t_01 + t_1- t) + phi_1)];
        vecs_1{3} = [-cos(sign_1*omega_1*(t_0 + t_01 + t_1- t) + phi_1);
                     -sin(sign_1*omega_1*(t_0 + t_01 + t_1- t) + phi_1)];
        vecs_1{4} = [sin(sign_1*omega_1*(t_0 + t_01 + t_1- t) + phi_1);
                     -cos(sign_1*omega_1*(t_0 + t_01 + t_1- t) + phi_1)];

        idx = mod(nd_traj, 4) + 1;

        traj_ = r1*((-sign_1*omega_1)^nd_traj)*vecs_1{idx};
    else
        error('Trajectory exceeds predefined time!');
    end
end
