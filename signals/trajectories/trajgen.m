function traj = trajgen(traj_type, t, T, A, B, options)
    switch traj_type
        case 'line'
            traj = my_line(t, T, A, B);
        case 'bezier'
            thetaA = options.thetaA;
            alphaA = options.alphaA;
            alphaB = options.alphaB;
            
            traj = my_bezier(t, T, A, B, thetaA, alphaA, alphaB);
        case 'exp'
            options.sys = sys;
            traj = my_dlin(t, T, A, B, sys, traj_type);
        otherwise
            error('Options are \''line\'', \''bezier\'', \''exp\''');
    end
end