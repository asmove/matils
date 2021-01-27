clear all
close all
clc

dt = 0.01;
tf = 1;
t = 0:dt:tf;

% Bézier curve - AB // orient(B)
% [m]
A = [0; 0];
B = [0; 1];

AB = B - A;

% [rad]
theta0 = 0;
theta1 = cart2pol(AB(1), AB(2));

% []
r0 = [cos(theta0); sin(theta0)];
r1 = [cos(theta1); sin(theta1)];

eps_ = 0.5;

C = A + r0*eps_;
D = B - r1*eps_;

Ps = {A'; C'; D'; B'};
% Ps = {A'; B'};

P_ts = [];
for i = 1:length(t)
    P_t = recursive_bezier(t(i), Ps);
    P_ts = [P_ts; P_t];
end

P_ts = [];
P_sym = [];
for i = 1:length(t)
    P_sym = [P_sym; recursive_bezier2(t(i), Ps)];
    P_ts = [P_ts; recursive_bezier(t(i), Ps)];
end

[n_P, ~] = size(P_ts);

% Bezier
hfig_bezier = my_figure();

plot(P_ts(:, 1), P_ts(:, 2), 'k-');
hold on
plot(P_sym(:, 1), P_sym(:, 2), 'k--');

hold on
plot(A(1), A(2), '-p', ...
    'MarkerFaceColor','red',...
    'MarkerSize',15);

hold on
plot(B(1), B(2), ...
    '-s','MarkerSize',10,...
    'MarkerEdgeColor','red',...
    'MarkerFaceColor',[1 .6 .6]);

hold off

axis square

title('Trajectories from A to B', ...
      'interpreter', 'latex');
xlabel('x');
ylabel('y');

aux_leg = legend({'B$\acute{e}$zier curve 1', ...
                  'B$\acute{e}$zier curve 2'}, ... 
                  'interpreter', 'latex', ...
                  'Location', 'northwest');

nd_degree = 1;

dP_ts1 = [];
dP_ts2 = [];
for i = 1:length(t)
    dP_t1 = recursive_ndbezier1(t(i), Ps, nd_degree);
    dP_t2 = recursive_ndbezier2(t(i), 0, tf, Ps, nd_degree);

    dP_ts1 = [dP_ts1; dP_t1];
    dP_ts2 = [dP_ts2; dP_t2];    
end

dP_ts1 = double(dP_ts1);
dP_ts2 = double(dP_ts2);

plot_config.titles = repeat_str('', 4);
plot_config.xlabels = {'', '', '', 'Iterations'};
plot_config.ylabels = {'$x(t)$', '$y(t)$', ...
                       '$\dot{x}(t)$', '$\dot{y}(t)$'};
plot_config.grid_size = [2, 2];
plot_config.legends = {{'Recursive', 'Symbolic'}, ...
                       {'Recursive', 'Symbolic'}, ...
                       {'Recursive', 'Symbolic'}, ...
                       {'Recursive', 'Symbolic'}};
plot_config.pos_multiplots = [1, 2, 3 4];
plot_config.markers = {{'-', '--'}, {'-', '--'}, ...
                       {'-', '--'}, {'-', '--'}};
plot_config.axis_style = 'square';

bezier_points = {[P_ts, dP_ts1], [P_sym, dP_ts2]};
[hfig_dbezier, axs] = my_plot(t, bezier_points, plot_config);

deriv_msg = sprintf('{d^{(%d)}}{dt^{(%d)}}', nd_degree, nd_degree);
msg = {'B$\acute{e}$zier curve 1', ...
       'B$\acute{e}$zier curve 2'};
aux_leg = legend(msg, ... 
                 'interpreter', 'latex', ...
                 'Fontsize', 12, ...
                 'Location', 'northwest');

axs{1}{1}.FontSize = 25;
axs{1}{2}.FontSize = 25;
axs{1}{3}.FontSize = 25;
axs{1}{4}.FontSize = 25;

% Save folder
path = [pwd '/../imgs/'];
posfix = [];

fname = 'bezier';
saveas(hfig_bezier, [path, fname], 'epsc')

fname = 'dbezier';
saveas(hfig_dbezier, [path, fname], 'epsc')


