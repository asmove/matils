function [tspan_, sol] = ode(method, func, x0, tspan, options)
    
    if(strcmp(method, 'rk'))
        [tspan_, sol] = rk_ode(func, x0, tspan, options.degree);
    elseif(strcmp(method, 'imp-euler'))
        [tspan_, sol] =  rk_impeuler(func, x0, tspan, options.precision);
    else
        error(strcat('Methods implemented: ', ...
                     char(39), 'rk', char(39), ' and  ', ...
                     char(39), 'imp-euler', char(39)));
    end
    
end

function [tspan, sol] =  rk_impeuler(func, x0, tspan, precision)
    
    % XXX: Fix
    error('Deprecated! Simulation time is to long.');
    
    len_t = length(tspan);
    
    wb = my_waitbar('Solving EDO - Implicit Euler');
    
    sol = x0;
    x_1 = x0;
    
    dt = tspan(2) - tspan(1);
    tf = tspan(end);
    
    n_t = length(tspan);
    
    for i = 2:n_t
        t_i = tspan(i);
        
        x_1 = sol(:, i-1);
        options = optimset('Display', 'iter', 'PlotFcns', @plot_objective);
        
        opt_func = @(x) norm(x - x_1 - dt*func(t_i + dt, x));        
        x = fminsearch(opt_func, x0);
        
        sol = [sol, x];
        
        wb.update_waitbar(i, n_t);
    end
end

function [tspan, sol] = rk_ode(func, x0, tspan, degree)
    [vec_t, vec_k, vec_x] = butcher_matrix(degree);
    
    PRECISION = 100;
    digits(PRECISION);
    
    len_t = length(vec_t);
    [len_row_k, len_col_k] = size(vec_k);
    
    if(len_t ~= len_row_k)
        msg = ['Butcher matrix function is deprecated for ', ...
               num2str(degree), ' degree.'];
        error(msg);
    end
    
    title = ['Solving EDO - RK', num2str(degree)];
    wb = my_waitbar(title);
    
    sol = x0;
    x_1 = sym(x0);
    
    dt = tspan(2) - tspan(1);
    tf = tspan(end);
    
    for i = 2:length(tspan)
        t = tspan(i);
        
        Ks = zeros(length(x0), len_col_k);
        for j = 1:len_row_k
            c_j = vec_t(j);
            a_j = vec_k(j, :)';
            
            t_j = t + c_j*dt;
            
            x_j = x_1 + dt*Ks*a_j;
            
            k_j = func(t_j, x_j);
            
            Ks(:, j) = k_j;
            
        end
        
        
        x = vpa(x_1) + dt*sym(Ks)*sym(vec_x);
        x_1 = sym(x);
        
        sol(:, end+1) = x;

        wb = wb.update_waitbar(t, tf);
    end
    
    sol = sym(sol);
end