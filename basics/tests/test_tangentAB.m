clear all
close all
clc

center_A = [0; 0];
center_B = [2; 2];

r0 = 1;
r1 = 0.5;

[B_1, B_2, ...
 C_1, C_2, ...
 x, y1, y2] = ...
    inner_tangentAB(center_A, center_B, r1, r2);

dtheta = 0.01;
thetas = 0:dtheta:2*pi;

circA = [];
circB = [];
for theta = thetas
    circA = [circA; r1*[cos(theta); sin(theta)]' + center_A'];
    circB = [circB; r2*[cos(theta); sin(theta)]' + center_B'];
end

hfig = my_figure();
plot(x, y1, 'b');
hold on;
plot(x, y2, 'b');
hold on;
plot(circA(:, 1), circA(:, 2), 'k');
hold on;
plot(circB(:, 1), circB(:, 2), 'r');
hold on;
plot(center_A(1), center_A(2), 'x');
hold on;
plot(center_B(1), center_B(2), 'x');
hold on;
plot(C_1(1), C_1(2), 'ko');
hold on;
plot(C_2(1), C_2(2), 'ko');
hold on;
plot(D_1(1), D_1(2), 'ko');
hold on;
plot(D_2(1), D_2(2), 'ko');
hold off;
axis equal;



