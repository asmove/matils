n_t  = length(tspan);

torque_vec = torque_ref*ones(n_t, 1);

w_vec = w_ss*ones(n_t, 1);
i_vec = i_ref*ones(n_t, 1);

y = {[torque, ang_vel, current], ...
     [torque_vec, i_vec]};

markers = {'-', '--'};

plot_config.titles = repeat_str('', 3);
plot_config.xlabels = [repeat_str('', 3), 't [s]'];
plot_config.ylabels = {'$\tau$ [N $\cdot$ m]', ...
                       '$\omega$ [$\frac{rad}{s}$]', ...
                       '$i$ [A]'};
plot_config.legends = {{'$\tau(t)$', '$\tau_{ss}(t)$'}, ...
                       {'$i(t)$', '$i_{ss}(t)$'}};
plot_config.grid_size = [1, 3];
plot_config.pos_multiplots = [1, 3];
plot_config.markers = {markers, markers};

hfig_x = my_plot(tspan, y, plot_config);

plot_config.titles = repeat_str('', 1);
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'$u$ [V]'};
plot_config.grid_size = [1, 1];
plot_config.plot_type = 'stairs';

hfig_u = my_plot(t_u, u, plot_config);
