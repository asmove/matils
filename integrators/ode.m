function [t, sol] = ode(degree, func, x0, tspan)
    [vec_t, vec_k, vec_x] = butcher_matrix(degree);
    
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
    x_1 = x0;
    
    dt = tspan(2) - tspan(1);
    tf = tspan(end);
    
    for i = 2:length(tspan)
        t = tspan(i);
        
        Ks = zeros(length(x0), len_col_k);
        for j = 1:len_row_k
            c_j = vec_t(j);
            a_j = vec_k(j, :)';
            
            
            k_j = func(t + c_j*dt, x_1 + dt*Ks*a_j);
            
            Ks(:, j) = k_j;
        end
        
        
        x = x_1 + dt*Ks*vec_x;
        
        x_1 = x;
        sol(:, end+1) = x;

        wb = wb.update_waitbar(t, tf);
    end
    
    wb.close_window();
end