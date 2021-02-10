t_o = simOut.output.time;

ang_vel = simOuts{1}.states.signals.values(:, 1);
current = simOuts{1}.states.signals.values(:, 2);

len_i = length(n_is);
n_t  = length(tspan);
n_tu  = length(t_o);

us = [];
for i = 1:len_i
    u = simOuts{i}.output.signals.values; 
    us = [us, u];
end

torque_vec = torque_ref*ones(n_t, 1);

us = interp1(t_o, us, tspan);
y = {torque_vec, us};

markers_u = {};
markers_u{end+1} = '--';
markers_u = [markers_u, repeat_str('-', len_i)];

legends_u = {};

legends_u{end+1} = '$\tau_{ss}(t)$]';

for i = 1:length(n_is)    
    legends_u{end+1} = sprintf('$n_d^i = %d$', n_is(i));
end

plot_config.titles = repeat_str('', 1);
plot_config.xlabels = [repeat_str('', 1)];
plot_config.ylabels = {'$\tau$ [N $\cdot$ m]'};
plot_config.legends = {legends_u};
plot_config.grid_size = [1, 1];
plot_config.pos_multiplots = [ones(1, len_i)];
plot_config.markers = {markers_u};

[hfig_x, axs] = my_plot(tspan, y, plot_config);

axs{1}{1}.FontSize = 25;

fname = '_states';
saveas(hfig_x, [path, prefix, fname], 'epsc');
