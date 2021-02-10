clear all
close all
clc

run('~/github/quindim/examples/1_mass/code/main.m');

run('./load_plant.m');
run('./load_control.m');
run('./load_trajectory.m');
run('./run_sim.m');
run('./run_plot.m');

