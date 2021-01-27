% Initial conditions
x0 = [0; 0];

e0 = torque_ref - k_i_val*x0(2);

load_system(model_name);

simMode = get_param(model_name, 'SimulationMode');
set_param(model_name, 'SimulationMode', 'normal');

cs = getActiveConfigSet(model_name);
mdl_cs = cs.copy;
set_param(mdl_cs, 'SolverType','Fixed-step', 'FixedStep', '1e-5', ...
                  'SaveState','on','StateSaveName','xoutNew', ...
                  'SaveOutput','on','OutputSaveName','youtNew');

t0 = tic();
simOut = sim(model_name, mdl_cs);
toc(t0);

output = simOut.output;
states = simOut.states;
u_n = simOut.u_n;

tspan = states.time;

ang_vel = states.signals.values(:, 1);
current = states.signals.values(:, 2);

t_u = u_n.time;
u = u_n.signals.values;

torque = output.signals.values;
