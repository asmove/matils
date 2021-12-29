clear all
close all
clc

% Load system
run('~/github/quindim/examples/omnirobot/code/main.m');

run('./load_plant.m');

model_name = 'tracking_model2';
run('./load_control.m');
run('./load_trajectory.m');
run('./run_sim.m');
run('./plot_simulation.m');
