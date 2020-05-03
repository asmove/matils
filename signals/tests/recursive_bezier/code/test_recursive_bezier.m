dt = 0.01;
tf = 1;
t = 0:dt:tf;

oracle = @(x) x(1)^2 + x(2)^2;

% Bézier curve - AB // orient(B)
% [m]
A = [0; 0];
B = [0; 1];
T = 10;

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

P_ts = [];
for i = 1:length(t)
    P_t = recursive_bezier(t(i), Ps);
    P_ts = [P_ts; P_t];
end

[n_P, ~] = size(P_ts);

hfig_bezier = my_figure();

% Bezier
plot(P_ts(:, 1), P_ts(:, 2), 'k-');

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
      'interpreter', 'latex', ...
      'Fontsize', 12);
xlabel('x');
ylabel('y');

aux_leg = legend({'B$\acute{e}$zier curve'}, ... 
                  'interpreter', 'latex', ...
                  'Fontsize', 12, ...
                  'Location', 'northwest');

nd_degree = 1;

dP_ts = [];
for i = 1:length(t)
    dP_t = recursive_ndbezier(t(i), Ps, nd_degree);
    dP_ts = [dP_ts; dP_t];
end

plot_config.titles = repeat_str('', 4);
plot_config.xlabels = {'', '', '', 'Iterations'};
plot_config.ylabels = {'$x(t)$', '$y(t)$', ...
                       '$\dot{x}(t)$', '$\dot{y}(t)$'};
plot_config.grid_size = [2, 2];

bezier_points = [P_ts, dP_ts];
[hfigs_bezier, axs] = my_plot(t, bezier_points, plot_config);

hfig_dbezier = my_figure();

% Bezier
plot(dP_ts(:, 1), dP_ts(:, 2), 'k-');

hold on
plot(dP_ts(1, 1), dP_ts(1, 2), '-p', ...
    'MarkerFaceColor','red',...
    'MarkerSize',15);

hold on
plot(dP_ts(end, 1), dP_ts(end, 2), ...
    '-s','MarkerSize',10,...
    'MarkerEdgeColor','red',...
    'MarkerFaceColor',[1 .6 .6]);

hold off

axis square

title('Trajectories from A to B', ...
      'interpreter', 'latex', ...
      'Fontsize', 12);
xlabel('x');
ylabel('y');

deriv_msg = sprintf('{d^{(%d)}}{dt^{(%d)}}', nd_degree, nd_degree);
msg = ['B$\acute{e}$zier curve - $\frac', deriv_msg, ' P(t)$'];
aux_leg = legend({msg}, ... 
                  'interpreter', 'latex', ...
                  'Fontsize', 12, ...
                  'Location', 'northwest');

P_ts_int = P_ts(1, :);
for i = 2:length(t)-1
    P_ts_int = [P_ts_int; P_ts_int(i - 1, :) + dt*(dP_ts(i, :) + dP_ts(i+1, :))/2];
end

% Bezier integration
hfig_bezier_int = my_figure();

hP = plot(P_ts_int(:, 1), P_ts_int(:, 2), 'k-');

hold on
plot(P_ts_int(1, 1), P_ts_int(1, 2), '-p', ...
    'MarkerFaceColor','red',...
    'MarkerSize',15);

hold on
plot(P_ts_int(end, 1), P_ts_int(end, 2), ...
    '-s','MarkerSize', 10,...
    'MarkerEdgeColor', 'red',...
    'MarkerFaceColor', [1 .6 .6]);

hold on
hP_ts = plot(P_ts(:, 1), P_ts(:, 2), 'r-');

hold on
plot(P_ts(1, 1), P_ts(1, 2), '-p', ...
    'MarkerFaceColor','red',...
    'MarkerSize',15);

hold on
plot(P_ts(end, 1), P_ts(end, 2), ...
    '-s','MarkerSize',10,...
    'MarkerEdgeColor','red',...
    'MarkerFaceColor',[1 .6 .6]);

hold off

axis square

title('Trajectories from A to B', ...
      'interpreter', 'latex', ...
      'Fontsize', 12);
xlabel('x');
ylabel('y');

deriv_msg = sprintf('{d^{(%d)}}{dt^{(%d)}}', nd_degree, nd_degree);
msg = ['$\int^{1}_{0} \, \frac', deriv_msg, ' P(t) \, dt$'];

aux_leg = legend([hP, hP_ts] , {'$P(t)$', msg}, ... 
                  'interpreter', 'latex', ...
                  'Fontsize', 12, ...
                  'Location', 'northwest');

% Save folder
path = [pwd '/../imgs/'];
posfix = [];

fname = 'bezier';
saveas(hfig_bezier, [path, fname], 'epsc')

fname = 'dbezier';
saveas(hfig_dbezier, [path, fname], 'epsc')

fname = 'bezier_int';
saveas(hfig_bezier_int, [path, fname], 'epsc')

