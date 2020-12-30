% Initial conditions
x0 = [0; 0; 0];

% Final time
tf = 5;

model_name = 'pwm_motor';

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

tspan = simOut.states.time;
torque = simOut.states.signals.values(:, 1);
theta = simOut.states.signals.values(:, 2);
ang_vel = simOut.states.signals.values(:, 3);
current = simOut.states.signals.values(:, 4);
pwm = simOut.pwm.signals.values;

