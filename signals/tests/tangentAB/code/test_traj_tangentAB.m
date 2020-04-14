clear all
close all
clc

% Percentage of segment between A and B
alpha_0 = 0.5;
alpha_1 = 0.45;

if((alpha_1 > 0) && (alpha_0 > 0) && ...
   (alpha_0 + alpha_1 > 1))
    error('Alpha_1 and Alpha_2 must sum 1 and be greater than 0');
end

A = [0; 0];
B = [1; 1];

v_0 = 0.5;
v_1 = 0.5;

theta_0 = 0;
theta_1 = pi/4;

t_0 = tan(theta_0);
t_1 = tan(theta_1);

signs = [-1, 1];

s_phi_0 = -sqrt(t_0^2/(1 + t_0^2));
c_phi_0 = sqrt(1/(1 + t_0^2));

phi_0 = atan2(c_phi_0, s_phi_0);

s_phi_1 = -sqrt(t_1^2/(1 + t_1^2));
c_phi_1 = sqrt(1/(1 + t_1^2));

phi_1 = atan2(c_phi_1, s_phi_1);

% Distance between path points
dAB = norm(A - B);

% Circle radius
r0 = alpha_0*dAB/2;
r1 = alpha_1*dAB/2;

% Angular velocity through path
omega_0 = v_0/r0;
omega_1 = v_1/r1;

% Centers of circles
rhat0 = [cos(phi_0); sin(phi_0)];
rhat0_perp = [-sin(phi_0); cos(phi_0)];
center_A = A - r0*rhat0;

rhat1 = [cos(phi_1); sin(phi_1)];
rhat1_perp = [-sin(phi_1); cos(phi_1)];
center_B = B + r1*rhat1;

[B_0, B_1, C_0, C_1, ...
 x, line0, line1] = inner_tangentAB(center_A, center_B, r0, r1);

dtheta = 0.01;
thetas = 0:dtheta:2*pi;

circA = [];
circB = [];
for theta = thetas
    circA = [circA; r0*[cos(theta); sin(theta)]' + center_A'];
    circB = [circB; r1*[cos(theta); sin(theta)]' + center_B'];
end

hfig = my_figure();

plot(A(1), A(2), 'k*');
msg = '\leftarrow A';
text(A(1), A(2), msg);
hold on;
plot(B(1), B(2), 'k*');
msg = '\leftarrow B';
text(B(1), B(2), msg);
hold on;

plot(line0(:, 1), line0(:, 2), 'b');
hold on;
plot(line1(:, 1), line1(:, 2), 'b');
hold on;

plot(circA(:, 1), circA(:, 2), 'r');
hold on;
plot(circB(:, 1), circB(:, 2), 'r');
hold on;

plot(center_A(1), center_A(2), 'kx');
hold on;
plot(center_B(1), center_B(2), 'kx');
hold on;

plot(C_0(1), C_0(2), 'ko');
hold on;
plot(C_1(1), C_1(2), 'ko');
hold on;
plot(B_0(1), B_0(2), 'ko');
hold on;
plot(B_1(1), B_1(2), 'ko');
hold on;
quiver(A(1), A(2), rhat0_perp(1), rhat0_perp(2));
hold on;
quiver(B(1), B(2), rhat1_perp(1), rhat1_perp(2));
hold off;

axis equal;





