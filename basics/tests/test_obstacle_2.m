clear all
close all
clc

reset(groot);

super_amplitudes = [1, 1];
super_exponents = [5, 1, 1, 1];
center = [0; 0];

c0 = 1;
d0 = 1;
exponent = 2;

obstacle = buildObstacle(center, super_amplitudes, super_exponents, c0, d0, exponent);

hfig = my_figure();
[hfig, X, Y, Z] = drawObstacle(hfig, obstacle);

filename = 'star_obstacle.mat';
save(filename, 'X', 'Y', 'Z');

