syms alpha_sym beta_sym real;
syms u_p u_m real;
syms Ts real;

% Motor linear matrices
A_ = A(2:3, 2:3);
B_ = B(2:3, :);
C_ = C(1, 2:3);

% PWM and sampling time [s]
Tpwm_val = 1e-3;
Ts_val = 1.1e-2;

% Duty cycle [%/100]
dalpha = 1e-2;
alphas = 0:dalpha:1;

n_alpha = length(alphas);

symbs = [alpha_sym; beta_sym; Ts];
ranks = [];

wb = my_waitbar('PWM rank matrix');

for i = 1:n_alpha
    alpha_ = alphas(i);
    [phi_Ts, gamma_Ts] = ss_PWM(alpha_, A_, B_, Tpwm_val, Ts_val);
    Mc = ctrb(phi_Ts, gamma_Ts);
    
    rank_ = rank(Mc);

    ranks = [ranks; rank_];
    
    wb.update_waitbar(i, n_alpha);
end

wb.close_window();

plot_config.titles = {''};
plot_config.xlabels = {'$\alpha$'};
plot_config.ylabels = {'rank($\mathcal{C}$)'};
plot_config.grid_size = [1, 1];

hfig_u = my_plot(alphas, ranks, plot_config);


