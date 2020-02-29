% clc; 
% close all; 
% clear all;
% 
% % Inputs and Declaration
% % solution stepsize and final time
% degrees = 1:12;
% 
% % Function declaration
% func = @(x, y) -y;
% 
% % Initial conditions
% x0 = 1;
% 
% tf = 1;
% lens_tspan = [3 10 30 100 300 1000];
% lens_tspan = lens_tspan';
% 
% % lapsed_time = {};
% 
% for i = 1:length(degrees)
%     degree = degrees(i);
%     
%     lapsed_time_d = [];
%     for j = 1:length(lens_tspan)
%         n = lens_tspan(j);
%         dt = tf/(n+1);
%         
%         tspan = 0:dt:tf;
%         
%         t0 = tic;
%         [t, sol] = ode(degree, func, x0, tspan);
%         dt = toc(t0);    
%         
%         lapsed_time_d(end+1) = dt;
%     end
%     
%     lapsed_time{degree} = lapsed_time_d;
% end

markers = {'-', '--', '.-', 's-', ...
           '*-', '-o', 'd-', 'p-', ...
           '+-', '^-', 'v-', 'h-', ...
           '>-', '<-'};
markers_2 = {markers{1:length(degrees)}};
legends = cellfun(@num2str, num2cell(degrees), 'UniformOutput', false);

y0 = lapsed_time{1}';

y1 = [];
for i = 1:length(lapsed_time)-1
    y1 = [y1, lapsed_time{i+1}'];
end

ys = {y0, y1};

% Plot and Comparison
plot_config.titles = {'Nummeric integration methods - Runge-Kutta method degree'};
plot_config.xlabels = {'Iterations'};
plot_config.ylabels = {'time $[s]$'};
plot_config.grid_size = [1, 1];
plot_config.plot_type = 'semilogx';
plot_config.legends = legends;
plot_config.pos_multiplots = ones(1, length(plot_config.legends)-1);
plot_config.markers = markers_2;

hfig = my_plot(lens_tspan, ys, plot_config);
set(gca, 'xscale','log', 'yscale','log');

% States
saveas(hfig, 'imgs/performance.eps', 'epsc');
