function paths = traj_tangentAB(A, B, theta_0, ...
                                v_0, v_01, v_1, ...
                                alpha_0, alpha_1)
    if((alpha_1 > 0) && (alpha_0 > 0) && ...
       (alpha_0 + alpha_1 > 1))
        error('alpha_0 and alpha_1 must sum 1 and be greater than 0');
    end
                            
    % Distance between path points
    BA = B - A;
    dAB = norm(BA);
    
    % Orientations
    theta_1 = atan2(BA(2), BA(1));
    
    % Centers of circles
    rhat0 = [cos(theta_0); sin(theta_0)];
    rhat1 = [cos(theta_1); sin(theta_1)];
    
    % Circle radius
    r0 = alpha_0*dAB;
    r1 = alpha_1*dAB;

    % Angular velocity through path
    omega_0 = v_0/r0;
    omega_1 = v_1/r1;

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

                fields = {'circA', 'circB', ...
                        'center_0', 'center_1', ...
                        'phi_0', 'phi_1', 'A', 'B', ...
                        'C_0', 'C_1', 'D_0', 'D_1', ...
                        'trajectory', 't_traj', ...
                        'dest_0', 'orig_1', 'line0', 'line1'};
                values = {circA , circB, center_0, center_1,...
                          phi_0, phi_1, A, B, ...
                          C_0, C_1, D_0, D_1, ...
                          {}, {}, [], [], line0, line1};

                path_i = cell2struct(values, fields, 2);
                paths{end+1} = path_i;
            end
        end

    end
    
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

            orig_center_0 = orig_0 - center_0;
            dest_center_0 = dest_0 - center_0;
            orig_center_1 = orig_1 - center_1;
            dest_center_1 = dest_1 - center_1;
            
            arg_od_0 = arguv(orig_center_0, dest_center_0);
            arg_od_1 = arguv(orig_center_1, dest_center_1);
            
            % Minus solution
            vec_0 = [cos(arg_od_0 + phi_0); sin(arg_od_0 + phi_0)];
            vec_1 = [cos(arg_od_1 + phi_1); sin(arg_od_1 + phi_1)];
            dest_0p = r0*vec_0 + center_0;
            dest_1p = r1*vec_1 + center_1;
            
            % Plus solution
            vec_0 = [cos(-arg_od_0 + phi_0); sin(-arg_od_0 + phi_0)];
            vec_1 = [cos(-arg_od_1 + phi_1); sin(-arg_od_1 + phi_1)];
            dest_0m = r0*vec_0 + center_0;
            dest_1m = r1*vec_1 + center_1;
            
            orient_0_p = [-sin(arg_od_0 + phi_0); cos(arg_od_0 + phi_0)];
            orient_0_m = -[-sin(-arg_od_0 + phi_0); cos(-arg_od_0 + phi_0)];
            orient_1_p = [-sin(arg_od_1 + phi_1); cos(arg_od_1 + phi_1)];
            orient_1_m = -[-sin(-arg_od_1 + phi_1); cos(-arg_od_1 + phi_1)];
            
            % They are equal
            EPS_ = 1e-5;
            
            norm_CD = norm(dest_0 - dest_1);
            CD_hat = (dest_1 - dest_0)/norm_CD;
            
            % They are equal
            if(norm(dest_0 - dest_0p) < EPS_)
                sign_0 = 1;
            else
                sign_0 = -1;
            end
            
            % They are equal
            if(norm(dest_1 - dest_1p) < EPS_)
                sign_1 = 1;
            else
                sign_1 = -1;
            end
            
            t_0 = arg_od_0/omega_0;
            t_01 = norm_CD/v_01;
            t_1 = arg_od_1/omega_1;
            
            vec_0 = [cos(sign_0*arg_od_0 + phi_0); sin(sign_0*arg_od_0 + phi_0)];
            vec_1 = [cos(sign_1*arg_od_1 + phi_1); sin(sign_1*arg_od_1 + phi_1)];
            dest_0_ = r0*vec_0 + center_0;
            dest_1_ = r1*vec_1 + center_1;
            
            orient_0 = sign_0*[-sin(sign_0*arg_od_0 + phi_0); ...
                                cos(sign_0*arg_od_0 + phi_0)];
            orient_1 = sign_1*[-sin(sign_1*arg_od_1 + phi_1); ...
                                cos(sign_1*arg_od_1 + phi_1)];
                            
            orient_B = sign_1*[-sin(phi_1); cos(phi_1)];
            
            if((abs(dot(orient_0, CD_hat) - 1) < EPS_) && ...
                abs(dot(orient_1, CD_hat) + 1) < EPS_)
                t_0
                t_01
                t_1
            
                dt = 1e-3;
                
                orient_1 = sign_1*[-sin(sign_1*arg_od_1 + phi_1); ...
                                    cos(sign_1*arg_od_1 + phi_1)];
                
                orient_B = sign_1*[-sin(phi_1); ...
                                    cos(phi_1)];
                                
                % First circle
                path_0 = [];
                t0 = 0:dt:t_0;
                
                for j = 1:length(t0)
                    vec_0 = [cos(sign_0*omega_0*t0(j) + phi_0); ...
                             sin(sign_0*omega_0*t0(j) + phi_0)];
                    pos_0 = r0*vec_0 + center_0;

                    path_0 = [path_0; pos_0'];
                end

                % Intermediate line
                path_1 = [];
                t1 = 0:dt:t_1;
                                
                for j = 1:length(t1)
                    vec_1 = [cos(sign_1*omega_1*t1(j) + phi_1); ...
                             sin(sign_1*omega_1*t1(j) + phi_1)];
                    pos_1 = r1*vec_1 + center_1;

                    path_1 = [path_1; pos_1'];
                end
                path_1 = flipud(path_1);
                
                % Second circle
                path_01 = [];
                d01 = norm(dest_1 - dest_0);
                t_01 = d01/v_01;
                t01 = 0:dt:t_01;
                
                for j = 1:length(t01)
                    P_i = dest_0 + (t01(j)/t_01)*(dest_1 - dest_0);
                    path_01 = [path_01; P_i'];
                end

                path_to_goal = {path_0; path_01; path_1};
                t_traj = {t0; t_0 + t01; t_0 + t_01 + t1};

                paths{i}.t_traj = t_traj;
                paths{i}.trajectory = path_to_goal;
                
                paths{i}.dest_0 = dest_0;
                paths{i}.orig_1 = dest_1;
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