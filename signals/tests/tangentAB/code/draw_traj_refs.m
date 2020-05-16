function hfigs_references = draw_traj_refs(path)
    t = [path.t_traj{1}'; path.t_traj{2}'; path.t_traj{3}'];

    dtraj = [];
    for i = 1:length(t)
        t_i = t(i);
        dy = path.traj_diff(t_i, 1);
        dtraj = [dtraj; dy'];
    end

    ddtraj = [];
    for i = 1:length(t)
        t_i = t(i);
        dy = path.traj_diff(t_i, 2);
        ddtraj = [ddtraj; dy'];
    end

    dddtraj = [];
    for i = 1:length(t)
        t_i = t(i);
        dy = path.traj_diff(t_i, 3);
        dddtraj = [dddtraj; dy'];
    end

    plot_config.titles = repeat_str('', 8);
    plot_config.xlabels = {'', '', '', '', '', '', '$t$ [s]', '$t$ [s]'};
    plot_config.ylabels = {'$x(t)$', '$y(t)$', ...
                           '$\dot{x}(t)$', '$\dot{y}(t)$', ...
                           '$\ddot{x}(t)$', '$\ddot{y}(t)$', ...
                           '$x^{(3)}(t)$', '$y^{(3)}(t)$'};
    plot_config.grid_size = [4, 2];

    traj = [path.trajectory{1}; path.trajectory{2}; path.trajectory{3}];

    ys = [traj, dtraj, ddtraj, dddtraj];

    [hfigs_references, ~] = my_plot(t, ys, plot_config);
end