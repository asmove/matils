clear all
close all
clc

run('~/github/quindim/examples/2D_unicycle/code/main.m')

dt = 0.01;
tf = 1;
t = 0:dt:tf;

nu = 5;

A = [0; 0];
B = [1; 1];

oracle = @(x) x(1)^2 + x(2)^2;

% --------- Straight line ---------
line2P = [];
for i = 1:length(t)
    t_i = t(i);
    Pt = A + (t_i/tf)*(B - A);
    line2P = [line2P; Pt'];
end

% --------- Bezier Curve ---------
% AB // orient(B) [m]
interval = 1;

% [rad]
theta0 = 0;
AB = B - A;
theta1 = cart2pol(AB(1), AB(2));

% []
r0 = [cos(theta0); sin(theta0)];
r1 = [cos(theta1); sin(theta1)];

eps_ = 0.1;

C = A + r0*eps_;
D = B - r1*eps_;

P = [A'; C'; D'; B'];

Ps_2 = bezier(P, 100);
n_P = size(Ps_2);
n_i = ceil(t_i/interval)*n_P;

% ------------------------------------
% Exponential and polynomial curves
pointA.t = 0;
pointA.coords = [A; 0];

pointB.t = interval;
pointB.coords = [B; pi/2];

points_ = [pointA; pointB];

traj_types = {'exp', 'polynomial'};

Ps_smooths = {};
xhat_smooths = {};
for j = 1:length(traj_types)
   [params_syms, ...
    params_sols, ...
    params_model] = gentrajmodel_2Drobot(sys, traj_types{j}, interval, points_);
    
    params_sols = double(params_sols);

    Ps_ = [];
    fs = [];
    for i = 1:length(t)
        t_i = t(i);
        symbs = [params_syms; sym('t'); sym('T')];
        vals = [double(params_sols); t_i; tf];
        
        P_i = double(my_subs(params_model, symbs, vals));
        
        f_i = oracle(P_i);
        fs = [fs; f_i];
        Ps_ = [Ps_; P_i'];
    end
    
    Ps_smooths{end+1} = Ps_;
    
    [xhat, ~] = expbary(oracle, Ps_, nu);
    
    xhat_smooths{end+1} = xhat;
end

traj_types = {'exp', 'polynomial'};
markers = {'c-', 'g.-'};

hfig = my_figure();

% Line point to point
plot(line2P(:, 1), line2P(:, 2), 'b-');

% Bezier 2
hold on;
plot(Ps_2(:, 1), Ps_2(:, 2), 'k-');

% Smoothsteps
Ps_smooths_1 = Ps_smooths{1};
plot(Ps_smooths_1(:, 1), ...
     Ps_smooths_1(:, 2), 'c.-');

Ps_smooths_2 = Ps_smooths{2};
plot(Ps_smooths_2(:, 1), ...
     Ps_smooths_2(:, 2), 'g.-');

hold on
[xhat, ~] = expbary(oracle, line2P, nu);
plot(xhat(1), xhat(2), 'bx');

hold on
[xhat, ~] = expbary(oracle, Ps_2, nu);
plot(xhat(1), xhat(2), 'k*');

hold on
[xhat, ~] = expbary(oracle, Ps_smooths_1, nu);
plot(xhat(1), xhat(2), 'cs');

hold on
[xhat, ~] = expbary(oracle, Ps_smooths_2, nu);
plot(xhat(1), xhat(2), 'gd');

hold off

axis square

grid

title('Trajectories from A to B', ...
      'interpreter', 'latex');
xlabel('x');
ylabel('y');

aux_leg = legend({'Line', ...
                  'Bezier curve 1', ...
                  'Exponential', ...
                  'Polynomial'}, ... 
                  'interpreter', 'latex', ...
                  'Location', 'northwest');
    
% Save folder
path = [pwd '/../imgs/'];
posfix = [];

fname = 'AB_concur.eps';
saveas(hfig, [path, fname], 'epsc')


