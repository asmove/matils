% Ellipsoid trajectory
a = 1;
b = 1;
omega = 1;

syms t_;
k = 3;

xy_t = [cos(k*t_)*cos(t_); cos(k*t_)*sin(t_)];
dxy_t = diff(xy_t, t_);
d2xy_t = diff(dxy_t, t_);
d3xy_t = diff(d2xy_t, t_);

trajs = [xy_t; dxy_t; d2xy_t; d3xy_t];

expr_syms = {trajs};

vars = {t};

Outputs = {{'trajs'}};

paths = {[model_name, '/trajectory_function']};

fun_names = {'TrajectoryGenerator'};
script_struct.expr_syms = expr_syms;
script_struct.vars = vars;
script_struct.Outputs = Outputs;
script_struct.paths = paths;
script_struct.fun_names = fun_names;

model_name = 'tracking_model2';
genscripts(sys, model_name, script_struct);
