B_avg = Vcc_val*B;

sys = ss(A, B_avg, C, D);
sysd_avg = c2d(sys, Ts_val);

[~, m] = size(B_avg);
[n_Ctilde, ~] = size(Ctilde);
[n_C, ~] = size(C);

[~, m] = size(sysd_avg.B);
n = length(A);

phi_aug = double([sysd_avg.A, zeros(n, n_Ctilde);...
                  -Ctilde, eye(n_Ctilde)]);

gamma_aug = double([sysd_avg.B;...
                    zeros(n_Ctilde, m)]);

C_aug = double([sysd_avg.C, zeros(n_C, n_Ctilde)]);

D_aug = double(sysd_avg.D);

sysd_aug = ss(phi_aug, gamma_aug, C_aug, D_aug, Ts_val);

phi_aug = double(phi_aug);
gamma_aug = double(gamma_aug);
C_aug = double(C_aug);

p_c_k = [-20; -25; -30];
p_d_l = [-20; -25; -30];
p_d_k = exp(Ts_val*p_c_k);

K_aug = acker(phi_aug, gamma_aug, p_d_k);

params.Kp = K_aug(:, 1:2);
params.Ki = -K_aug(:, 3);

