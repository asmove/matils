clear all
close all
clc

c0 = 1;
d0 = 1;

dx = 1e-3;
xs = 0:dx:d0;

coeffs = [c0/d0^2, -2*c0/d0, c0];

ys = zeros([length(xs), 1]);
for i = 1:length(xs)
    ys(i) = parable(xs(i), coeffs);
end

hfig = my_figure();

plot(xs, ys);

axis equal
axis square
grid