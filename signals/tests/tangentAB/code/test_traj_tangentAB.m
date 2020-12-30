clear all
close all
clc

% Percentage of segment between A and B
alpha_0 = 0.2;
alpha_1 = 0.2;

% Begin and end points
A = [0; 0];
B = [1; 1];
theta_0 = 0;

% Velocities on respective paths
v_0 = 1;
v_01 = 1;
v_1 = 1;

paths = traj_tangentAB(A, B, theta_0, v_0, v_01, v_1, ...
                       alpha_0, alpha_1);

for i = 1:length(paths)
    path = paths{i};

    hfig = draw_traj(path);

    % Speeds plot
    filepath = ['../imgs/circle_line', num2str(i), '.eps'];
    saveas(hfig, filepath, 'epsc');

    hfigs_references = draw_traj_refs(path);

    % Speeds plot
    filepath = ['../imgs/references', num2str(i), '.eps'];
    saveas(hfigs_references, filepath, 'epsc');
end


