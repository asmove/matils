n_T = 3;
T = tf/n_T;
precision = 1e-1;
limiter = -(1/T)*log(precision);

poles_ = {-limiter*ones(3, 1), ...
          -limiter*ones(3, 1)};
is_dyn_control = true;

% Load control law
u_struct = calc_control_2DRobot(sys, poles_);

% u requirements
dz = u_struct.dz;
v_ = u_struct.v;
v_sym = u_struct.v_sym;
u = u_struct.u;
x_sym = u_struct.x_sym;
ref_syms = u_struct.ref_syms;

expr_syms = {dz; v_; u};

var_zv = {x_sym, ref_syms};
var_u = {x_sym, v_sym};

vars = {var_zv, var_zv, var_u};

outputs = {{'dz'}, {'v'}, {'u'}};

paths = {[model_name, '/Control/z_calculation/compensator_dz'], ...
         [model_name, '/Control/control_function_v'], ...
         [model_name, '/Control/control_function_u']};

fun_names = {'compensator_dz', ...
             'control_function_v', ...
             'control_function_u'};

kwargs.paths = paths;
kwargs.vars = vars;
kwargs.outputs = outputs;
kwargs.fun_names = fun_names;
kwargs.expr_syms = expr_syms;

load_controller(model_name, kwargs);


