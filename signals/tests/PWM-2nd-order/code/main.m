% close all 
% REQUIRES ROBOTICS4FUN LIBRARY
% https://github.com/brunolnetto/Robotics4fun
close all
clc

run('~/github/Robotics4fun/examples/RLC/code/main.m');

max_val = 30;
min_val = -30;
alpha = 0.5;

% [Hz]
f = 200;
T = 1/f;
u_func = @(t, x) pwm_signal(t, max_val, min_val, alpha, T);

model_params = sys.descrip.model_params;
R = model_params(2);
L = model_params(1);
C = 1/model_params(3);

p12 = roots([1 R/L 1/(L*C)]);

% System properties
alpha = R/(2*L);
beta = 1/(L*C) - R^2/(4*L^2);

if(beta > 0)
    w_d = sqrt();
    xi = w_d/alpha;
    zeta = sqrt(1/(1 + xi^2));
    w_n = alpha/zeta;
else
    w_n = 1/sqrt(L*C);
    zeta = (R/2)*sqrt(C/L);
end

perc = 1/100;
tr = -log(perc)/(zeta*w_n);
scaler1 = 40;
tf = scaler1*tr;

scaler2 = 10;
dt = T/scaler2;
time = 0:dt:tf;
time = time';

x0 = [0; 0];
sol = validate_model(sys, time, x0, u_func, false);
sol = sol';

clear_inner_close_all();
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
plot_config.ylabels = {'$u(t)$', '$i(t)$'};
plot_config.grid_size = [2, 1];

my_plot(time, us, plot_config);

% Plot properties
plot_config.titles = {'', ''};
plot_config.xlabels = {'', 't [s]'};
plot_config.ylabels = {'$q(t)$', '$i(t)$'};
plot_config.grid_size = [2, 1];

my_plot(time, sol, plot_config);