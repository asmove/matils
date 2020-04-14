% % close all 
% % REQUIRES ROBOTICS4FUN LIBRARY
% % https://github.com/brunolnetto/Robotics4fun
% close all
% clc

run('~/github/Robotics4fun/examples/RLC/code/main.m');

max_val = 10;
min_val = -5;
alpha_ = 0.3;

model_params = sys.descrip.model_params;
R = model_params(2);
L = model_params(1);
C = 1/model_params(3);

% System properties
omega_ = 1/sqrt(L*C);
T_ = 1/omega_;
n_PWM = 10;
n_T = 1;
T_PWM = T_/n_PWM;
tf = n_T*T_;

scaler2 = 100;
dt = tf/scaler2;
time = 0:dt:tf;
time = time';

u_func = @(t, x) pwm_signal(t, max_val, min_val, alpha_, T_PWM);
% u_func = @(t, x) alpha_*max_val + (1 - alpha_)*min_val;

x0 = [0; 0];
sol = validate_model(sys, time, x0, u_func, false);
sol = sol';

us = [];
x_dummy = zeros(size(x0));
for i = 1:length(time) 
    t_i = time(i);
    u = u_func(t_i, x_dummy);
    us = [us; u];
end

% Plot properties
plot_config.titles = {'', ''};
plot_config.xlabels = {'', 't [s]'};
plot_config.ylabels = {'$u(t)$'};
plot_config.grid_size = [1, 1];

hfig_u = my_plot(time, us, plot_config);

% Plot properties
plot_config.titles = {'', ''};
plot_config.xlabels = {'', 't [s]'};
plot_config.ylabels = {'$q(t)$', '$i(t)$'};
plot_config.grid_size = [2, 1];

hfig_sol = my_plot(time, sol, plot_config);

path = [pwd '/../imgs/'];
fname = ['states'];
saveas(hfig_sol, [path, fname], 'epsc');

path = [pwd '/../imgs/'];
fname = ['inputs'];
saveas(hfig_u, [path, fname], 'epsc');

