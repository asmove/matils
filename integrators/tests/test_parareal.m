clear all
close all
clc

tf = 5;
dt = 0.1;
tspan = 0:dt:tf;
 
odefun = @(t, x) -x;
x0 = 1;

 sol = my_parareal(odefun, x0, tspan);
 
 % Generalized coordinates
plot_info.titles = {''};
plot_info.xlabels = {'$t$ [s]'};
plot_info.ylabels = {'$x$'};
plot_info.grid_size = [1, 1];

% States plot
hfig = my_plot(tspan, sol, plot_info);