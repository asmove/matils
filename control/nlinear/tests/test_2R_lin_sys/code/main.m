% Load model
run('~/github/quindim/examples/n_R/code/main.m');

% States
q = sys.kin.q;
p = sys.kin.p{end};

q_p = [q; p];

% States and input linearization values
x_WP = [pi; pi; 0; 0];
u_WP = [0; 0];

% Sampling time
Ts = 0.1;

ndelay_u = 0;

sys.descrip.y = sys.kin.q;

linsys =  lin_sys(sys, x_WP, u_WP, Ts);

Phi = linsys.discrete.systems{1}.ss.a;
Gamma = linsys.discrete.systems{1}.ss.b;
C = linsys.discrete.systems{1}.ss.c;
D = linsys.discrete.systems{1}.ss.d;

[~, m] = size(Gamma);
[p, ~] = size(C);

nds_i = ones(m, 1);
nds_o = ones(p, 1);

[Phi_d, Gamma_d, C_d, D_d] = delay_io(Phi, Gamma, C, D, nds_i, nds_o);

sys_dd = ss(Phi_d, Gamma_d, C_d, D_d);

[nulls, poles, is_ctrb, is_obsv] = plant_behaviour(sys_dd);

scaler = 10;
n = length(Phi_d);

n_ctrb = is_ctrb.eigs(~is_ctrb.is_ctrb);

poles_d = exp(-scaler*Ts*rand(n, 1));

K = place(Phi_d, Gamma_d, poles_d);

eig(Phi_d - Gamma_d*K)
