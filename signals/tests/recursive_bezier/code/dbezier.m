dP_ts = [];
for i = 2:(length(t)-1)
    P_t = recursive_bezier(t(i), Ps);
    
    dPi = (P_ts(i+1, :) - P_ts(i-1, :))/(2*dt);
    dP_ts = [dP_ts; dPi];
    P_ts = [P_ts; P_t];
end

hfig = my_figure();

% Bezier
plot(dP_ts(:, 1), dP_ts(:, 2), 'k-');

axis square

title('Trajectories from A to B', ...
      'interpreter', 'latex', ...
      'Fontsize', 12);
xlabel('x');
ylabel('y');

aux_leg = legend({'B$\acute{e}$zier curve'}, ... 
                  'interpreter', 'latex', ...
                  'Fontsize', 12, ...
                  'Location', 'northwest');