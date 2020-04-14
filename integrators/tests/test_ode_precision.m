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
precision = 1e-5;

% Function declaration
func = @(x, y) -y;

% Initial conditions
x0 = 1;

% input vector
tspan = 0:dt:tf;
tspan = tspan';

% Analytical Exact Solution
y_exact = x0*exp(-tspan);

legends = [{'Exact'}, ...
           cellfun(@num2str, num2cell(degrees), 'UniformOutput', false), ...
           {'Implicit Euler'}];
markers = gen_plot_markers(length(legends));

errors = zeros(length(tspan)-1, length(legends)-1);
sols = zeros(length(tspan), length(legends));

methods = {'imp-euler', 'rk'};

acc = 1;
for j = 1:length(methods)
    method = methods{j}; 
    if(strcmp(method, 'rk'))
        for i = 1:length(degrees)
            degree = degrees(i);
            
            options.degree = degree;
            [tspan_, sol] = ode(method, func, x0, tspan, options);
            sol = sol';
            
            % Errors
            errors(:, acc) = -log10(abs(y_exact(2:end) - sol(2:end)));

            % Solutions
            sols(:, acc) = sol;
        
            acc = acc + 1;
        end
    else
        options.precision = precision;
        [tspan_, sol] = ode(method, func, x0, tspan, options);
        sol = sol';
        
        % Errors
        errors(:, acc) = -log10(abs(y_exact(2:end) - sol(2:end)));

        % Solutions
        sols(:, acc) = sol;
        
        acc = acc + 1;
    end
end

% Solution plot
plot_config.titles = {'Nummeric integration methods - y(t) = $e^{-t}$'};
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'$y(t)$'};
plot_config.grid_size = [1, 1];
plot_config.legends = legends;
plot_config.markers = markers;
plot_config.pos_multiplots = ones(1, length(legends)-1);

ys = {y_exact, sols};
hfig_sol = my_plot(tspan, ys, plot_config);

% Error plot
legends_errors = {legends{2:end}};
markers_errors = {markers{2:end}};

plot_config.titles = {'Relative error to exact solution'};
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'$-\log_{10}(|e(t)|_{\infty})$'};
plot_config.grid_size = [1, 1];
plot_config.legends = legends_errors;
plot_config.markers = markers_errors;
plot_config.pos_multiplots = ones(1, length(legends_errors)-1);

errors = {errors(:, 1), errors(:, 2:end)};

hfig_errors = my_plot(tspan(2:end), errors, plot_config);

% States
saveas(hfig_sol, 'imgs/sols.eps', 'epsc');
saveas(hfig_errors, 'imgs/errors.eps', 'epsc');

