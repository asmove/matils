clear all
close all
clc

% [m]
A = [0; 0];
B = [1; 1];

% [rad]
theta0 = 0;
theta1 = pi/2;

% [m/s]
v0 = 1;

% []
r0 = [cos(theta0); sin(theta0)];
r1 = [cos(theta1); sin(theta1)];

% Calculate C
A_ml = [r0, -r1];
delta_ml = B - A;

mu_lambda = inv(A_ml)*delta_ml;

C = A + mu_lambda(1)*r0;

P = [A'; C'; B'];

dx = 1e-2;
xf = 1;
x = 0:dx:xf;

Ps = bezier(P, 100);

hfig_AB_non_concur = my_figure();
plot(P(:, 1), P(:, 2), 'x');
hold on;
plot(Ps(:, 1), Ps(:, 2), '-');
hold off
axis square

title('Points with orientation of B \textbf{not} coincidental to point A', 'interpreter', 'latex');
xlabel('x');
ylabel('y');

% [m]
A = [0; 0];
B = [1; 1];

% [rad]
theta0 = 0;
theta1 = pi/4;

% []
r0 = [cos(theta0); sin(theta0)];
r1 = [cos(theta1); sin(theta1)];

eps_ = 0.1;

C = A + r0*eps_;
D = B - r1*eps_;

P = [A'; C'; D'; B'];

dx = 1e-2;
xf = 1;
x = 0:dx:xf;

Ps = bezier(P, 100);

hfig_AB_concur = my_figure();
plot(P(:, 1), P(:, 2), 'x');
hold on;
plot(Ps(:, 1), Ps(:, 2), '-');
hold off
axis square

title('Points with orientation of point B coincidental to point A', 'interpreter', 'latex');
xlabel('x');
ylabel('y');

% Save folder
path = [pwd '/../imgs/'];
posfix = [];

fname = 'AB_concur';
saveas(hfig_AB_concur, [path, fname], 'epsc')

fname = 'AB_non_concur';
saveas(hfig_AB_non_concur, [path, fname], 'epsc')


