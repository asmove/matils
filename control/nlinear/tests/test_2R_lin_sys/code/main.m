
% Load model
run('~/github/quindim/examples/furuta_pendulum/code/main.m');

% States
q = sys.kin.q;
p = sys.kin.p{end};

q_p = [q; p];

% States and input linearization values
x_WP = zeros(size(q_p));
u_WP = 0;

% Sampling time
Ts = 0.1;

ndelay_u = 0;

sys.descrip.y = sys.kin.q;

linsys =  lin_sys(sys, x_WP, u_WP, Ts, ndelay);

Phi = linsys.discrete.systems{2}.ss.a;
Gamma = linsys.discrete.systems{2}.ss.b;
C = linsys.discrete.systems{2}.ss.c;
D = linsys.discrete.systems{2}.ss.d;

[~, m] = size(Gamma);
[p, ~] = size(C);

nds_i = ones(m, 1);
nds_o = ones(p, 1);

[Phi_d, Gamma_d, C_d, D_d] = delay_io(Phi, Gamma, C, D, nds_i, nds_o);

