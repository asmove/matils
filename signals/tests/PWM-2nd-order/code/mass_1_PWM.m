% close all 
% REQUIRES ROBOTICS4FUN LIBRARY
% https://github.com/brunolnetto/Robotics4fun
% close all
% clc
% 
% run('~/github/Robotics4fun/examples/1_mass/code/main.m');

max_val = 1;
min_val = 0;
alpha = 0.5;

% [Hz]
f = 20;
T = 1/f;
u_func = @(t, x) pwm_signal(t, max_val, min_val, alpha, T);

model_params = sys.descrip.model_params;
m = model_params(1);
b = model_params(2);
k = model_params(3);

p12 = roots([m b k]);

% System properties
A = [0, 1; -k/m -b/m];
b = [0; 1/m];

xss = -inv(A)*b*max_val;
u_func = @(t, x) pwm_signal(t, 1, 0, alpha, T);

x0 = [0; 0];
scaler = 10;
dt = T/scaler;
tf = 1;

time = 0:dt:tf;

sol = validate_model(sys, time, x0, u_func, false);
sol = sol';

% clear_inner_close_all();
% us = [];
% x_dummy = zeros(size(x0));
% for i = 1:length(time) 
%     t_i = time(i);
%     u = u_func(t_i, x_dummy);
%     us = [us; u];
% end
% 
% % Plot properties
% plot_config.titles = {'', ''};
% plot_config.xlabels = {'', 't [s]'};
% plot_config.ylabels = {'$u(t)$', '$i(t)$'};
% plot_config.grid_size = [2, 1];
% 
% my_plot(time, us, plot_config);

% Plot properties
plot_config.titles = {'', ''};
plot_config.xlabels = {'', 't [s]'};
plot_config.ylabels = {'$q(t)$', '$i(t)$'};
plot_config.grid_size = [2, 1];

my_plot(time, sol, plot_config);