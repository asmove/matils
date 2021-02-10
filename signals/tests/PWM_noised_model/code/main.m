% Author: Bruno Peixoto
% Date: 22/01/21

% Model parameters from:
%     - https://www.mathworks.com/help/control/ug/dc-motor-control.html
% Description: This script models a DC toy-motor actioned by a:
%               - Discrete PI controller;
%               - Discrete PWM-average controller;
%               - Discrete PWM-based controller;
% load_params: Load motor parameters
% sim_system:   Simulate system with parameters from load_params and
%               model_name
% plot_signals: plot simulation signals
clear all
close all
clc

% --------------------- PWM state feedback control ---------------------
run('load_pwm_controller.m');

model_name = 'pwm_controlled_system';
run('sim_controlled_system.m');

prefix = 'pwm';
run('plot_pwm_signals.m');

% -------------- PWM delayed input output feedback control --------------
nd = 5;
n_is = 1:nd;
simOuts = {};

sys_ = {};

for i = 1:length(n_is)
    n_i = n_is(i);
    
    run('load_pwm_delayed_controller.m');
    
    sys_props.Phi = Phi_aug;
    sys_props.Gamma = Gamma_aug;
    sys_props.C = C_aug;
    sys_props.D = D_aug;
    sys_props.K_aug = K_aug;
    
    t_f = 2;
    
    sys_{end+1} = sys_props;
    
    model_name = 'pwm_delayed_controlled_system';
    run('sim_controlled_system.m');
    simOuts{end+1} = simOut;
end

prefix = 'pwm_delayed';
run('plot_pwm_delayed_signals.m');

% --------------------- PWM output feedback control ---------------------
run('load_pwm_pred_controller.m');

n_i = 3;
model_name = 'pwm_pred_controlled_system';
run('sim_controlled_system.m');

prefix = 'pwm_delayed_pred';
run('plot_pwm_pred_signals.m');

% -------------- PWM delayed input output feedback control --------------
run('load_pwm_delayed_pred_controller.m');

model_name = 'pwm_pred_delayed_controlled_system';
run('sim_controlled_system.m');

prefix = 'pwm_delayed_pred';
run('plot_pwm_pred_signals.m');

% --------- PWM control-predicted noised system ---------
run('load_pwm_delayed_pred_noised_controller.m');

model_name = 'pwm_delayed_pred_noised_controlled_system';
run('sim_controlled_system.m');

prefix = 'pwm_delayed_pred_noised';
run('plot_pwm_pred_signals.m');

