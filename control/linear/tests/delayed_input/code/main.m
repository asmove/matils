clear all
close all
clc

run('load_params.m');

sys = ss(A, B, C, D);
sys_d = c2d(sys, Ts_val);

Phi = sys_d.a;
Gamma = sys_d.b;
C = sys_d.c;
D = sys_d.d;

[n, m] = size(Gamma);
[p, ~] = size(C);

nds_i = ones(m, 1);
nds_o = ones(p, 1);

s_nd_i = sum(nds_i);
s_nd_o = sum(nds_o);

[Phi_d, Gamma_d] = delayed_input_linsys(Phi, Gamma, nds_i);

C_d = [C, zeros(p, s_nd)];

[Phi_d, C_d] = delayed_output_linsys(Phi_d, C_d, nds_o);

Gamma = [Gamma; zeros(s_nd_o, p)];
