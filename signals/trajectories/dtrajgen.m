function dtraj = dtrajgen(traj_type, t, T, A, B)
    switch traj_type
        case 'line'
            dtraj = my_dline(n_d, traj_type, t, T, A, B);
        case 'bezier'
            dtraj = my_dbezier(n_d, t, T, A, B, thetaA, alphaA, alphaB);
        case 'exp'
            dtraj = my_dlin(n_d, t, T, A, B, sys, traj_type);
        otherwise
            error('Options are \''line\'', \''bezier\'', \''exp\''!');
    end

end

function dtraj = my_dline(n_d, t, T, A, B)    
    n = length(A);

    if(n_d == 0)
        error();
    elseif(n_d == 1)
        d_nd_P = (B - A)/T;
    else
        d_nd_P = zeros(n, 1);
    end
end

function dtraj = my_dbezier(n_d, t, T, A, B, thetaA, alphaA, alphaB)
    syms t_;
    traj = my_bezier(t_, T, A, B, thetaA, alphaA, alphaB);
    
    dtraj = traj;
    for i = 1:n_d
        dtraj = diff(dtraj, t_);
    end
    
end

function dtraj = my_dlin(n_d, t, T, A, B, sys, traj_type)
    pointA = struct('coords', A, 't', 0);
    pointB = struct('coords', B, 't', T);
    
    Ps = [pointA; pointB];

    [params_syms, ...
     params_sols, ...
     params_model] = gentrajmodel_2Drobot(sys, traj_type, T, );
    
    params_sols = double(params_sols);
    
    [xhat, ~] = expbary(oracle, Ps_, nu);
    
    xhat_smooths{end+1} = xhat;
end

function dtraj = my_dlin(n_d, t, T, A, B, sys, traj_type)
    pointA = struct('coords', A, 't', 0);
    pointB = struct('coords', B, 't', T);
    
    Ps = [pointA; pointB];

    [params_syms, ...
     params_sols, ...
     params_model] = gentrajmodel_2Drobot(sys, traj_type, T, );
    
    params_sols = double(params_sols);
    
    [xhat, ~] = expbary(oracle, Ps_, nu);
    
    xhat_smooths{end+1} = xhat;
end

