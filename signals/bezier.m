function Ps = bezier(P, N)
% This function constructs a Bezier curve from given control points. 
% Briefly, a Bezier curve tangenciate two or more coordinates, given 
% points. P is a  vector of control points. N is the number of points to 
% calculate.
%
% Example:
%
% P = [0 0; 1 1; 2 5; 5 -1];
% x = (0:0.0001:5);
% y = bezier(length(x), P);
% plot(x, y, P(:, 1), P(:, 2), 'x-', 'LineWidth', 2); set(gca, 'FontSize', 16)

[Np, ~] = size(P); 
t = linspace(0, 1, N);

n = Np-1;

Ps = [];
for i = 1:N
    t_i = t(i);
    
    P_t = zeros(size(P(1, :)));
    for j = 0:n
         comb_in = factorial(n)/(factorial(j)*factorial(n - j));
         point_j = P(j+1, :);
         
         % B is the Bernstein polynomial value
         Pin = comb_in*(1 - t_i)^(n - j)*t_i^j;
         
         P_t = P_t + point_j*Pin;
    end
    
    Ps = [Ps; P_t];
end
