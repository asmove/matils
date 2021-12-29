model_name = 'bary_source_seeking';
model_path = [cpath, '/simutils/', model_name];

ctx = struct('');
ctx(1).model_name = model_name;
ctx(1).model_path = model_path;

% Control function u
expr_syms = {u_expr, v_expr};
vars = {{x_sym, v_sym, refs}, {x_sym, refs}};

Outputs = {{'u'}, {'v'}};

paths = {[ctx.model_name, '/control/control_function_u'], ...
         [ctx.model_name, '/control/control_function_v']};

fun_names = {'ControlFunction_u', 'ControlFunction_v'};

script_struct.expr_syms = expr_syms;
script_struct.vars = vars;
script_struct.Outputs = Outputs;
script_struct.paths = paths;
script_struct.fun_names = fun_names;

genscripts(sys, ctx, script_struct);

