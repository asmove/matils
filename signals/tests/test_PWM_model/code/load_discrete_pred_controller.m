C = [1 0];
D = 0;

sys = ss(A, B, C, D);
sysd = c2d(sys, Ts_val);

Phi = sysd.a;
Gamma = sysd.b;
C = sysd.c;

% Tracking linear system
[~, m] = size(B);
[n_Ctilde, ~] = size(Ctilde);
[n_C, ~] = size(C);

[~, m] = size(sysd.B);
n = length(A);

phi_aug = double([sysd.A, zeros(n, n_Ctilde);...
                  -Ctilde, eye(n_Ctilde)]);

gamma_aug = double([sysd.B;...
                    zeros(n_Ctilde, m)]);

C_aug = double([sysd.C, zeros(n_C, n_Ctilde)]);

D_aug = double(sysd.D);

sysd_aug = ss(phi_aug, gamma_aug, C_aug, D_aug, Ts_val);

phi_aug = double(phi_aug);
gamma_aug = double(gamma_aug);
C_aug = double(C_aug);

% Controller
p_c_k = [-15; -20; -25];
p_d_k = exp(Ts_val*p_c_k);

K_aug = acker(phi_aug, gamma_aug, p_d_k);

Kp = K_aug(:, 1:2);
Ki = -K_aug(:, 3);

n = length(Phi);
[n_r, ~] = size(Ctilde);

params.Kp = Kp;
params.Ki = Ki;

% Observer
p_c_l = [-25; -30];
p_d_l = exp(Ts_val*p_c_l);

Phi = sysd.a;
C = sysd.c;

% L = place(Phi', Phi'*C', p_d_l)';
L = place(Phi', C', p_d_l)';
params.L = L;

Phi_ = [ Phi - Gamma*Kp, Gamma*Ki, Gamma*Kp; ...
         -Ctilde, eye(n_r), Ctilde; ...
         zeros(n, n), zeros(n, n_r), Phi - L*C];

params.Phi = Phi;
params.Gamma = Gamma;
params.C = C;


