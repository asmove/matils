clear all
close all
clc

thetas = 0:0.001:2*pi;

coords = [];

for theta = thetas
    coord = hypersph2cart(theta)';
    coords = [coords; coord];
end

coord_i = hypersph2cart(0);
plot(coord_i(1), coord_i(2), 's')

hold on

coord_f = hypersph2cart(2*pi);
plot(coord_f(1), coord_f(2), 'p')

hold on

plot(coords(:, 1), coords(:, 2))
