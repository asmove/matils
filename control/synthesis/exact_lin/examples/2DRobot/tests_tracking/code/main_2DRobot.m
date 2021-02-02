clear all
close all
clc

run('~/github/quindim/examples/2D_unicycle/code/main.m');

model_name = 'compensator_tracking_model';

gen_scripts(sys, model_name);

run('./load_control.m');

syms t_ T;

% Time vector
tf = 5;

run('./load_trajectories.m');

P0 = [0; 0];
P1 = [1; 1];

theta0 = 0;
thetaf = pi/2;

% [x; y; phi; v; omega; dv]
x0 = [P0; theta0; 1; 0];
z0 = 0;

simOut = sim_block_diagram(model_name, x0);

run([pwd, '/plot_nonhol.m']);

