n_t  = length(tspan);
w_ss = ang_vel(end);

beta_ = 1-alpha_;

u_mean = max_val*alpha_ + min_val*beta_;
i_mean = (1/R_val)*(u_mean - k_w_val*w_ss);
torque_mean = n_val*k_i_val*i_mean;
% 
A_rl = A_sym(2:3, 2:3);
B_rl = B_sym(2:3);

x_ss = double(subs(-inv(A_rl)*B_rl*u_mean, symbs, vals));

torque_vec = torque_mean*ones(n_t, 1);

w_vec = w_ss*ones(n_t, 1);
i_vec = i_mean*ones(n_t, 1);

y = {[torque, theta, ang_vel, current], ...
     [torque_vec, w_vec, i_vec]};

markers = {'-', '--'};

plot_config.titles = repeat_str('', 4);
plot_config.xlabels = [repeat_str('', 3), 't [s]'];
plot_config.ylabels = {'$\tau$ [N $\cdot$ m]', '$\theta$ [rad]', ...
                       '$\omega$ [$\frac{rad}{s}$]', '$i$ [A]'};
plot_config.legends = {{'$\tau(t)$', '$\tau_{ss}(t)$'}, ...
                       {'$\omega(t)$', '$\omega_{ss}(t)$'}, ...
                       {'$i(t)$', '$i_{ss}(t)$'}};
plot_config.grid_size = [2, 2];
plot_config.pos_multiplots = [1, 3, 4];
plot_config.markers = {markers, markers, markers};

hfig_x = my_plot(tspan, y, plot_config);

plot_config.titles = {''};
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'$u_{pwm}(t)$'};
plot_config.grid_size = [1, 1];

hfig_u = my_plot(tspan, pwm, plot_config);