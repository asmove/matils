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

run('load_params.m');

% Discrete-only controlled system
run('load_discrete_controller.m');
% 
% model_name = 'discrete_controlled_system';
% run('sim_controlled_system.m');
% 
% run('plot_discrete_signals.m');

% Average-PWM controlled system
run('load_pwm_avg_controller.m');

model_name = 'pwm_avg_controlled_system';
run('sim_controlled_system.m');

run('plot_pwm_signals.m');

% % Discrete controller project, PWM controlled system
% run('load_pwm_controller.m');
% 
% model_name = 'pwm_controlled_system';
% run('sim_controlled_system.m');
% 
% run('plot_pwm_signals.m');
