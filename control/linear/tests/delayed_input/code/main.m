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

[Phi, Gamma, C, D] = delay_io(Phi, Gamma, C, D);