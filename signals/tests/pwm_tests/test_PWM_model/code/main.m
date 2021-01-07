% Author: Bruno Peixoto
% Date: 30/12/20

% Model parameters from: 
%     - https://www.mathworks.com/help/control/ug/dc-motor-control.html
% Description: This script models a DC toy-motor actioned by a PWM signal.
% load_params: Load motor parameters
% sim_system:   Simulate system with parameters from load_params
% ss_value:     State space and controllability for system with
%               PWM period Tpwm and sample period Ts
% plot_signals: plot simulation signals

clear all
close all
clc

run('load_params.m');
run('sim_system.m');
run('plot_signals.m');

run('ss_value.m');



