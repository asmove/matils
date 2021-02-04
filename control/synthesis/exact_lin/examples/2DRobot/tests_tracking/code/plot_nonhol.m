close all

t = simOut.states.time;
sol = simOut.states.signals.values;

% ----------- Reference plot -----------
wb = my_waitbar('Trajectory calculation');

n_t = length(t);

vars = [];
for i = 1:n_t
    vars = [vars; double(subs(trajs.', t_, t(i)))];

    wb.update_waitbar(i, n_t);
end

wb.close_window();

plot_info_q.titles = repeat_str('', 8);
plot_info_q.ylabels = {'$x_{\star}$', '$y_{\star}$', ...
                       '$\dot{x}_{\star}$', '$\dot{y}_{\star}$', ...
                       '$\ddot{x}_{\star}$', '$\ddot{y}_{\star}$', ...
                       '$x^{(3)}_{\star}$', '$y^{(3)}_{\star}$'};
plot_info_q.xlabels = repeat_str('$t$ [s]', 8);
plot_info_q.grid_size = [4, 2];

hfig_references = my_plot(t, vars, plot_info_q);

% --------------------------------------

% ----- States and reference plot ------

wb = my_waitbar('Trajectory calculation');

n_t = length(t);

ref_vals = [];
for i = 1:length(t)
    ref_vals = [ref_vals; double(subs(trajs.', t_, t(i)))];

    wb.update_waitbar(i, n_t);
end

plot_config.titles = repeat_str('', 3);
plot_config.xlabels = [repeat_str('', 2), {'$t$ [s]'}];
plot_config.ylabels = {'$x$', '$y$', '$\theta$'};
plot_config.legends = {{'$x$', '$x^{\star}$'}, {'$y$', '$y^{\star}$'}};
plot_config.grid_size = [3, 1];
plot_config.pos_multiplots = [1, 2];
plot_config.markers = {{'-', '--'}, {'-', '--'}};

traj_xy = ref_vals(:, 1:2);
ys = {sol(:, 1:3), traj_xy};

hfig_states = my_plot(t, ys, plot_config);

% --------------------------------------

% ------------- Speed plot --------------
plot_config.titles = repeat_str('', 2);
plot_config.xlabels = [repeat_str('', 1), {'$t$ [s]'}];
plot_config.ylabels = {'$v$', '$\omega$'};
plot_config.grid_size = [2, 1];

hfig_speeds = my_plot(t, sol(:, 4:5), plot_config);
% --------------------------------------

% -------------- x-y Plot --------------
lims = 1.5;

hfig_statesxy = my_figure();
plot(sol(:, 1), sol(:, 2), '-');
hold on;
plot(traj_xy(:, 1), traj_xy(:, 2), '--');
hold off;
legend({'$r(t)$', '$r^{\star}(t)$'}, 'interpreter', 'latex')
xlabel('$x$ [m]', 'interpreter', 'latex');
ylabel('$y$ [m]', 'interpreter', 'latex');

axis equal;
axis([-lims lims -lims lims]);

% ----------- Torque plot ---------------
tu_s = simOut.u.time;
input_torque = simOut.u.signals.values;

[n_t, n_u] = size(input_torque);
tu_s = linspace(0, tf, n_t);

plot_info_u.titles = repeat_str('', 2);
plot_info_u.ylabels = {'$\tau_{\theta}$', '$\tau_{\phi}$'};
plot_info_u.xlabels = repeat_str('$t$ [s]', 2);
plot_info_u.grid_size = [2, 1];

hfigs_u = my_plot(tu_s, input_torque, plot_info_u);
% --------------------------------------

% ----------- Speed plot ---------------
C = sys.kin.C;
q = sys.kin.q;
p = sys.kin.p{end};

q_p = [q; p];

x_pq = x_sym(1:length(q_p), 1);
qp_x = subs(C*p, q_p, x_pq);

symbs = sys.descrip.syms;
model_params = sys.descrip.model_params;

qp_t = [];
wb = my_waitbar('Loading states on time');
for i = 1:length(t)
    t_i = t(i);
    qp_i = subs(qp_x, [x_pq; symbs.'], [sol(i, :)'; model_params.'])';
    qp_t = [qp_t; qp_i];

    wb = wb.update_waitbar(i, length(t));
end

R_val = model_params(2);

qp_ref = [];
wb = my_waitbar('Loading desired states');
for i = 1:length(t)
    xp_yp_d = ref_vals(i, 3:4);
    xpp_ypp_d = ref_vals(i, 5:6);
    theta_d = atan2(xp_yp_d(2), xp_yp_d(1));
    v_d = norm(xp_yp_d);
    
    thetap_d = (-xpp_ypp_d(1)*sin(theta_d) + ...
                xpp_ypp_d(2)*cos(theta_d))/v_d;

    qp_ref = [qp_ref; xp_yp_d, thetap_d];

    wb = wb.update_waitbar(i, length(t));
end

plot_info_qp.titles = repeat_str('', 4);
plot_info_qp.ylabels = {'$\dot{x}$', '$\dot{y}$', ...
                        '$\dot{\theta}$'};
plot_info_qp.xlabels = [repeat_str('', 3), {'$t$ [s]'}];
plot_info_qp.legends = {{'$\dot{x}$', '$\dot{x}^{\star}$'}, ...
                       {'$\dot{y}$', '$\dot{y}^{\star}$'}, ...
                       {'$\dot{\theta}$', '$\dot{\theta}^{\star}$'}};
plot_info_qp.pos_multiplots = [1, 2, 3];
plot_info_qp.grid_size = [3, 1];
plot_info_qp.markers = {{'-', '--'}, {'-', '--'}, ...
                        {'-', '--'}};
                    
hfig_qpt = my_plot(t, {qp_t, qp_ref}, plot_info_qp);

saveas(hfig_references, ['../imgs/references'], 'epsc');
saveas(hfig_states, ['../imgs/states'], 'epsc');
saveas(hfig_speeds, ['../imgs/speeds'], 'epsc');
saveas(hfig_statesxy, ['../imgs/statesxy'], 'epsc');
saveas(hfig_qpt, ['../imgs/dstates'], 'epsc');
saveas(hfigs_u, ['../imgs/input'], 'epsc');

