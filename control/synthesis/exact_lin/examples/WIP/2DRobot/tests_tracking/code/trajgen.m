function trajs_dtrajs = trajgen(type, n_d, options)
    syms t_ T;
    
    trajs_dtrajs = sym(zeros(n_d+1, 1));
    
    switch type
        case 'flower'
            % Flower trajectory
            k = options.k;
            xy_t = [cos(k*t_)*cos(t_); cos(k*t_)*sin(t_)];
            
            dtraj_i = xy_t;
            
            dtrajs = sym(zeros(n_d+1, 1));
            for i = 1:n_d
                dtraj_i = diff(dxy_i1, t_);
                dtrajs = [dtrajs; dtraj_i];
                dtraj_i = dtraj_i1;
            end
            
            trajs_dtrajs(2:end) = dtrajs;
        
        case 'bezier'
            % % Bezier curve
            alphaA = options.alphaA;
            alphaB = options.alphaB;
            
            P0 = options.P0;
            P1 = options.P1;
            theta0 = options.theta0;
            
            xy_t = vpa(expand(bezier_path(t_, T_traj, P0, P1, theta0, alphaA, alphaB)));
            dxy_t = diff(xy_t, t_);
            d2xy_t = diff(xy_t, t_);
            d3xy_t = diff(xy_t, t_);
        
        case 'line'
            % % Line trajectory
            xy_t = P0 + t_*(P1 - P0);
        
        otherwise
            
    end
end