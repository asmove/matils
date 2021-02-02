% options.traj_type = 'line';
% options.theta0 = theta0;
% options.traj_type = 'bezier';
% 
% traj = trajgen(options.traj_type, t, T, A, B);
% dtraj = dtrajgen(options.traj_type, t, T, A, B, 1);

% % Arc-line curve
% traj_params = struct('');
% 
% v = norm(P1 - P0)/T_traj;
% 
% v_0 = v;
% v_01 = v; 
% v_1 = v;
% 
% % Percentage under AB distance
% alpha_0 = 0.2;
% alpha_1 = 0.2;
% 
% traj_params = traj_tangentAB(P0, P1, theta0, ...
%                              v_0, v_01, v_1, ...
%                              alpha_0, alpha_1);
% 
% traj_params = traj_params{1};
% 
% % Geometrical properties
% arg0 = traj_params.arg0;
% dCD = traj_params.dCD;
% arg1 = traj_params.arg1;
% 
% r0 = traj_params.r0;
% r1 = traj_params.r1;
% 
% v = (r0*arg0 + dCD + r1*arg1)/T_traj;
% v_0 = v;
% v_01 = v;
% v_1 = v;
% 
% t_0 = traj_params.t_0;
% t_01 = traj_params.t_01;
% t_1 = traj_params.t_1;
% 
% traj_params = traj_tangentAB(P0, P1, theta0, v_0, v_01, v_1, alpha_0, alpha_1);
% traj_params = traj_params{1};

% ref_func = @(t) tangentAB_reffunc(t, traj_params);

% % Exponential and polynomial curves
% % traj_type = 'exp';
% traj_type = 'polynomial';
% 
% point0.t = 0;
% point0.coords = [P0; theta0];
% point1.t = T_traj;
% point1.coords = [P1; thetaf];
% 
% points_ = [point0; point1];
% 
% % Coefficients generation
% [params_syms, ...
%  params_sols, ...
%  params_model] = gentrajmodel_2Drobot(sys, ...
%                                       traj_type, ...
%                                       T_traj, points_);
% 
% params_sols = double(params_sols);
% 
% xy_t = subs(params_model, ...
%             [params_syms; T; sym('t')], ...
%             [params_sols; T_traj; t_]);
% 
% ref_func = @(t) subs(trajs, t_, t);

% % Line trajectory
% xy_t = P0 + t_*(P1 - P0);

% % Bezier curve
% alphaA = 0.3;
% alphaB = 0.3;
% xy_t = vpa(expand(bezier_path(t_, T_traj, P0, P1, theta0, alphaA, alphaB)));
% dxy_t = diff(xy_t, t_);
% d2xy_t = diff(xy_t, t_);
% d3xy_t = diff(xy_t, t_);

% Flower trajectory
k = 3;
xy_t = [cos(k*t_)*cos(t_); cos(k*t_)*sin(t_)];
dxy_t = diff(xy_t, t_);
d2xy_t = diff(dxy_t, t_);
d3xy_t = diff(d2xy_t, t_);

trajs = [xy_t; dxy_t; d2xy_t; d3xy_t];

var = [t_];
output = {'ref'};
path = [model_name, '/trajectory_function'];
fun_name = 'trajectory_generator';

load_simblock(model_name, path, fun_name, ...
              trajs, var, output)

save_system(model_name);
close_system(model_name);
