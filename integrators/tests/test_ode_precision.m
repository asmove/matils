% This code is made by Ahmed Eltahan
% This code intends to solve 1st order ODE Runge-Kutta-Fehlberg 
% procedure which is 6th order accuracy 
clc; 
close all; 
clear all;

% Inputs and Declaration
% solution stepsize and final time
dt = 0.1;
tf = 5;

degrees = 1:12;
% degrees = 2;

% Function declaration
func = @(x, y) -y;

% Initial conditions
x0 = 1;

% input vector
tspan = 0:dt:tf;
tspan = tspan';

% Analytical Exact Solution
y_exact = x0*exp(-tspan);

errors = zeros(length(tspan)-1, length(degrees));
sols = zeros(length(tspan), length(degrees));
for i = 1:length(degrees)
    degree = degrees(i);
    
    [t, sol] = ode(degree, func, x0, tspan);
    sol = sol';

    % Errors
    errors(:, i) = -log10(abs(y_exact(2:end) - sol(2:end)));

    % Solutions
    sols(:, i) = sol;
end

errors = {errors(:, 1), errors(:, 2:end)};
markers = {'-', '--', '.-', 's-', ...
           '*-', '-o', 'd-', 'p-', ...
           '+-', '^-', 'v-', 'h-', ...
           '>-', '<-'};

markers_1 = markers(1:length(degrees)+1);
legends = cellfun(@num2str, num2cell(degrees), 'UniformOutput', false);

% Plot and Comparison
plot_config.titles = {'Nummeric integration methods - y(t) = $e^{-t}$'};
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'$y(t)$'};
plot_config.grid_size = [1, 1];
plot_config.legends = [{'Exact'}, legends];
plot_config.pos_multiplots = ones(1, length(plot_config.legends)-1);
plot_config.markers = markers_1;

ys = {y_exact, sols};
hfig_sol = my_plot(tspan, ys, plot_config);

markers_2 = {markers{2:length(degrees)+1}};

plot_config.titles = {'Relative error to exact solution'};
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'$-\log_{10}(|e(t)|_{\infty})$'};
plot_config.grid_size = [1, 1];
plot_config.legends = legends;
plot_config.pos_multiplots = ones(1, length(plot_config.legends)-1);
plot_config.markers = markers_2;

hfig_errors = my_plot(tspan(2:end), errors, plot_config);

% States
saveas(hfig_sol, 'imgs/sols.eps', 'epsc');
saveas(hfig_errors, 'imgs/errors.eps', 'epsc');

