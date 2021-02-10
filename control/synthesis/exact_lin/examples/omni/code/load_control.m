H = simplify_(sys.dyn.H);
invH = inv(H);

u = sys.descrip.u;
h = simplify_(sys.dyn.h);
Z = simplify_(sys.dyn.Z);
C = simplify_(sys.kin.C);

q = sys.kin.q;
p = simplify_(sys.kin.p{end});

plant = [C*p; invH*(-h + Z*u)];

G = simplify_(equationsToMatrix(plant, u));
f = simplify_(plant - G*u);

y = sys.kin.q(1:3);
x = [sys.kin.q; sys.kin.p];

out = exact_lin(f, G, y, x);

pole_c = -20;
delta = sum(out.deltas);
poles_v = pole_c*rand([delta, 1]);

A = double(out.As);
B = double(out.Bs);
z_tilde = out.z_tilde;

K = place(A, B, poles_v);
v_expr = vpa(-K*z_tilde);

q = sys.kin.q;
p = sys.kin.p{end};

u_expr = out.u;
v_sym = out.v;
refs = out.y_ref_sym;
x_sym = [q; p];

symbs = sys.descrip.syms;
model_params = sys.descrip.model_params;

u_expr = my_subs(u_expr, symbs, model_params);
v_expr = my_subs(v_expr, symbs, model_params);

% Control function u
expr_syms = {u_expr, v_expr};
vars = {{x_sym, v_sym, refs}, {x_sym, refs}};

model_name = 'tracking_model2';

Outputs = {{'u'}, {'v'}};

paths = {[model_name, '/control/control_function_u'], ...
         [model_name, '/control/control_function_v']};

fun_names = {'ControlFunction_u', 'ControlFunction_v'};

script_struct.expr_syms = expr_syms;
script_struct.vars = vars;
script_struct.Outputs = Outputs;
script_struct.paths = paths;
script_struct.fun_names = fun_names;

genscripts(sys, model_name, script_struct);

