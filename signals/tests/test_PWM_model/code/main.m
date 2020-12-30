clear all
close all
clc

syms J b R L k_i k_w n real
syms th thp curr u real

symbs = [J b R L k_i k_w n];

% J thpp = - b thp + k_i i
% 0      = u_pwm - k_w thp - R i

thp_eq = thp;
thpp_eq = (-b/J)*thp + (k_i/J)*curr;
ip_eq = u - k_w*thp - R*curr;

eqs = [thp_eq; thpp_eq; ip_eq];

y_eq = [(-b*thp + k_i*curr)*n; th; thp; curr];

states = [th; thp; curr];

A = equationsToMatrix(eqs, states);
B = equationsToMatrix(eqs, u);
C = equationsToMatrix(y_eq, states);
D = equationsToMatrix(y_eq, u);

% A = [0 1 0; 0 -b/J k_i/J; 0 -k_w/L -R/L];
% B = [0; 0; 1/L];
% C = [0 -b k_i; 0 1 0; 0 0 1];
% D = [0; 0; 0];

% Rotor inertia [kg m^3]
J_val = 0.02;

% Viscuous parameter
b_val = 0;

% Resistance value
R_val = 2.0;

% Inductance [H]
L_val = 0.5;

% Current motor constant 
k_i_val = 0.1;

% Speed motor constant [V.s/rad]
k_w_val = 0.1;

% Gear ratio
n_val = 50;

vals = [J_val b_val R_val L_val ...
        k_i_val k_w_val n_val];

A = double(subs(A, symbs, vals));
B = double(subs(B, symbs, vals));
C = double(subs(C, symbs, vals));
D = double(subs(D, symbs, vals));

max_val = 12;
min_val = 0;
alpha = 0.5;
T = 1e-3;

u_mean = max_val*alpha + min_val*(1-alpha);

% Initial conditions
x0 = [0; 0; 0];

% Final time
tf = 20;

model_name = 'pwm_motor';

load_system(model_name);

simMode = get_param(model_name, 'SimulationMode');
set_param(model_name, 'SimulationMode', 'normal');

cs = getActiveConfigSet(model_name);
mdl_cs = cs.copy;
set_param(mdl_cs, 'SolverType','Fixed-step', 'FixedStep', '1e-5', ...
                  'SaveState','on','StateSaveName','xoutNew', ...
                  'SaveOutput','on','OutputSaveName','youtNew');

t0 = tic();
simOut = sim(model_name, mdl_cs);
toc(t0);

tspan = simOut.states.time;
torque = simOut.states.signals.values(:, 1);
theta = simOut.states.signals.values(:, 2);
ang_vel = simOut.states.signals.values(:, 3);
current = simOut.states.signals.values(:, 4);
pwm = simOut.pwm.signals.values;

n_t  = length(tspan);
w_ss = ang_vel(end);

i_mean = (1/R_val)*(u_mean - k_w_val*w_ss);
torque_mean = n_val*k_i_val*i_mean;

y = {[torque, theta, ang_vel, current], ...
     [torque_mean*ones(n_t, 1), ...
      w_ss*ones(n_t, 1), ...
      i_mean*ones(n_t, 1)]};

markers = {'-', '--'};

plot_config.titles = repeat_str('', 4);
plot_config.xlabels = [repeat_str('', 3), 't [s]'];
plot_config.ylabels = {'$\tau$ [N $\cdot$ m]', ...
                       '$\theta$ [rad]', ...
                       '$\omega$ [$\frac{rad}{s}$]', ...
                       '$i$ [A]'};
plot_config.legends = {{'$\tau(t)$', '$\tau_{ss}(t)$'}, ...
                       {'$i(t)$', '$i_{ss}(t)$'}, ...
                       {'$\omega(t)$', '$\omega_{ss}(t)$'}};
plot_config.grid_size = [2, 2];
plot_config.pos_multiplots = [1, 3, 4];
plot_config.markers = {markers, markers, markers};

hfig_x = my_plot(tspan, y, plot_config);

plot_config.titles = {''};
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'$u_{pwm}(t)$'};
plot_config.grid_size = [1, 1];

hfig_u = my_plot(tspan, pwm, plot_config);

