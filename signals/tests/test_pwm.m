clear all
close all
clc

dt = 0.01;
tf = 10;
t = 0:dt:tf;

max_val = 1;
min_val = -1;
alpha = 0.9;
T = 1;

vals = [];
for i =  1:length(t)
    t_i = t(i);
    val = pwm_signal(t_i, max_val, min_val, alpha, T);
    vals = [vals; val];
end

% x-mean coordinates
plot_config.titles = {''};
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'$u(t)$'};
plot_config.grid_size = [1, 1];

hfig_x = my_plot(t, vals, plot_config);
