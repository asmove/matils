run('load_pwm_avg_controller.m');

% Observer
p_c_l = [-25; -30];
p_d_l = exp(Ts_val*p_c_l);

Phi = sysd.a;
Gamma = sysd.b;
C = sysd.c;

L = place(Phi', C', p_d_l)';
params.L = L;

params.Phi = Phi;
params.Gamma = Gamma;
params.C = C;
