clear all
close all
clc

amplitudes = [1, 1];
exponents = [6, 1, 7, 8];

center = [0; 0];
orientation = 0;

radius_fun = @(phase) superformula(phase, amplitudes, exponents); 

thetas = 0:0.001:2*pi;

coords = [];

for theta = thetas
    coord = radialSurf(center, theta, radius_fun)';
    coords = [coords; coord];
end

plot_info.titles = {''};
plot_info.xlabels = {'$x-axis$'};
plot_info.ylabels = {'$y-axis$'};
plot_info.grid_size = [1, 1];
plot_info.axis_style = 'equal';

[h, axs] = my_plot(coords(:, 1), coords(:, 2), plot_info);
