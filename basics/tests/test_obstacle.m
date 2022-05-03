clear all
close all
clc
reset(groot);

super_amplitudes = [1, 1];
super_exponents = [4, 1, 1, 1];
center = [1; 1];

radius_fun = @(theta) superformula(theta, super_amplitudes, super_exponents);

c0 = 1;
d0 = 1;

a = 1/d0;
b = -1;
exponent = 2;
coeffs = c0*linePowerCoeffs(a, b, exponent);

% dx = 1e-3;
% xs = 0:dx:d0;
% 
% ys = zeros(1, length(xs));
% for i = 1:length(xs)
%     ys(i) = my_polyval(coeffs, xs(i));
% end
% 
% plot(xs, ys)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Instances plot
xm = -3;
xM = 3;
ym = -3;
yM = 3;

n = 50;
x = linspace(xm, xM, n);
y = linspace(ym, yM, n);

nx = length(x);
ny = length(y);

wb = my_waitbar('Loading function.');

Z = zeros(nx, ny);
for i = 1:nx
    xi = x(i);
    for j = 1:ny 
        yi = y(j);
        [th, rho_xy] = my_cart2pol(xi, yi, center);
        
        rho_obs = radius_fun(th);
        
        d = rho_xy-rho_obs;
        
        if(d < 0)
          Z(i, j) = c0;
        elseif(d > d0)
          Z(i, j) = 0;
        else
          Z(i, j) = my_polyval(coeffs, d);
        end
        
        wb.update(i*nx + j, nx*ny);
    end
end

[X,Y] = meshgrid(x,y);

wb.close_window()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

run('textInterpretersToLatex');

surf(X, Y, Z)

shading flat
xlim([xm xM])
ylim([ym yM])
zlim([0 c0])

% thetas = 0:0.001:2*pi;
% 
% coords = [];
% 
% for theta = thetas
%     coord = radialSurf(center, theta, radius_fun)';
%     coords = [coords; coord];
% end
% 
% hfig = my_figure();
% plot(coords(:, 1), coords(:, 2));
% hold on;
% 
% title_tmp = '[$m$, $n_1$, $n_2$, $n_3$] = [%.2f, %.2f, %.2f, %.2f]';
% title_string = sprintf(title_tmp, exponents(1), exponents(2), exponents(3), exponents(4));
% title(title_string);
% 
% hold off
% axis equal
% axis square
% grid
% 
% filename = 'obstacle.eps';
% root_path = [pwd, '/imgs'];
% imgs_path = [root_path, '/', filename];
% 
% saveas(hfig, imgs_path, 'epsc');
