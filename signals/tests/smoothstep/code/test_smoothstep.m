clear all
close all
clc

T = 2;
T_begin = -1;
T_end = 1;
y_begin = -1;
y_end = 1;
dt = 0.01;

time = -T:dt:T;

degrees = {0, 1, 2, 3};

degrees_str = {};
for i = 1:length(degrees)
    degrees_str{end+1} = ['Degree $', num2str(degrees{i}), '$'];
end

ys = zeros(length(time), length(degrees));

wb = my_waitbar('Trajectory generation');

for j = 1:length(degrees)
    for i = 1:length(time)
        ys(i, j) = smoothstep(time(i), ...
                              T_begin, T_end, ...
                              y_begin, y_end, ...
                              degrees{j});
        
        wb.update_waitbar((j - 1)*length(time) + i, ...
                          length(time)*length(degrees));
    end
end

degrees_str = {};

for i = 1:length(degrees)
    degrees_str{end+1} = num2str(degrees{i} + 1);
end

n_d = length(degrees);

plot_config.titles = repeat_str('', 1);
plot_config.xlabels = {'x'};
plot_config.ylabels = {'y'};
plot_config.grid_size = [1, 1];
plot_config.legends = {degrees_str};
plot_config.pos_multiplots = ones(n_d-1, 1);
plot_config.markers = {repeat_str('--', n_d)};
plot_config.axis_style = 'square';

data = {ys(:, 1), ys(:, 2:end)};

[hfig, ~] = my_plot(time, data, plot_config);

axis equal

% Save folder
path = [pwd '/../imgs/'];
posfix = [];

fname = 'smoothsteps.eps';
saveas(hfig, [path, fname], 'epsc')
