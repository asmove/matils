syms J b R L k_i k_w n real
syms th thp curr u real

symbs = [J b R L k_i k_w n];

% J thpp = - b thp + k_i i
% 0      = u_pwm - k_w thp - R i

thp_eq = thp;
thpp_eq = (-b/J)*thp + (k_i/J)*curr;
ip_eq = u - k_w*thp - R*curr;

eqs = [thp_eq; thpp_eq; ip_eq];

y_eq = [n*k_i*curr; th; thp; curr];

states = [th; thp; curr];

A = equationsToMatrix(eqs, states);
B = equationsToMatrix(eqs, u);
C = equationsToMatrix(y_eq, states);
D = equationsToMatrix(y_eq, u);

% Rotor inertia [kg m^3]
J_val = 0.02;

% Viscuous parameter
b_val = 0.2;

% Resistance value
R_val = 2;

% Inductance [H]
L_val = 0.5;

% Current motor constant 
k_i_val = 0.1;

% Speed motor constant [V.s/rad]
k_w_val = 0.1;

% Gear ratio
n_val = 50;

vals = [J_val b_val R_val L_val ...
        k_i_val k_w_val n_val];

A = double(subs(A, symbs, vals));
B = double(subs(B, symbs, vals));
C = double(subs(C, symbs, vals));
D = double(subs(D, symbs, vals));

min_val = 0;
max_val = 2;
alpha = 0.5;
T = 1e-3;
