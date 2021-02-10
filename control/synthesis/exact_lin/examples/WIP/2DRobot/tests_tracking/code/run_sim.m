P0 = [0; 0];
P1 = [1; 1];

theta0 = 0;
thetaf = pi/2;

% [x; y; phi; v; omega; dv]
x0 = [P0; theta0; 1; 0];
z0 = 0;

% Time vector
tf = 3;

simOut = sim_block_diagram(model_name, x0);
