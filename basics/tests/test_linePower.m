clear all
close all
clc

run('textInterpretersToLatex');

c0 = 1;
d0 = 1;

a = 1/d0;
b = -1;

exponent_max = 5;

dx = 1e-3;
xs = 0:dx:d0;

hfig = my_figure();    

for exponent = 1:exponent_max
    coeffs = c0*linePowerCoeffs(a, b, exponent);
    
    ys = zeros([length(xs), 1]);
    for i = 1:length(xs)
        ys(i) = my_polyval(coeffs, xs(i));
    end
    
    legend_name = sprintf('%.1f', exponent);
    plot(xs, ys, 'DisplayName', legend_name);

    hold on;
end

hold off

title_tmp = 'Parameters [$c_0$, $d_0$] given by [%.2f, %.2f]';
title_string = sprintf(title_tmp, c0, d0);
title(title_string);

axis equal
axis square
grid
legend show

children = get(gcf, 'Children');

title(children(1), 'k', 'Interpreter', 'latex')