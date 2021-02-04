% Discrete system
sys_c = ss(A, B, C, D);
sys_d = c2d(sys_c, Ts_val);

Phi = sys_d.a;
Gamma = sys_d.b;
C = sys_d.c;
D = sys_d.d;

% 
poles_c = [-10; -15];
poles_d = exp(Ts_val*poles_c);

K = place(Phi, Gamma, poles_d);

K_str = controller_to_str(K, true, true);

disp(K_str);

disp('Poles of controlled system: ')
disp(eig(Phi - Gamma*K))

disp('Project poles: ')
disp(poles_d)

