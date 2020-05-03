function [sol, errors] = my_parareal(odefun, x0, tspan)
    % Coarse solution
    options.degree = 4;
    [~, y_k] = ode('rk', odefun, x0, tspan, options);
    y_k = y_k';
    
    y_km1 = y_k;
    y_kp1 = zeros(size(y_k));
    
    MAX_ITERATIONS = 100;
    eps_ = 1e-3;
    dt = 0.002;
    
    t0_ = tic;
    
    errors = [];
    is_eos = false;
    while(~is_eos)
        k = 1;
        n = length(tspan)-1;
        
        y_kp1(1, :) = x0';
        
        t0 = tic;
        
        WaitMessage = parfor_wait(n, 'Waitbar', true);
        parfor j = 1:n
            y_km1_j = y_km1(j, :)';
            
            degree = 5;
            [~, y_k_j] = ode('rk', odefun, y_km1_j, tspan(j:j+1), struct('degree', degree));
            y_k_j = y_k_j';
            y_kp1(j+1, :) = y_k_j(2, :);
            
            WaitMessage.Send;
            pause(dt);
        end
        
        WaitMessage.Destroy;
        
        is_eos = (max(max(abs(y_kp1 - y_km1))) < eps_) || k == MAX_ITERATIONS;
        
        prec = double(max(max(abs(y_kp1 - y_km1))));
        msg = sprintf('Precision achieved: %.2f', prec);
        disp(msg);
        
        msg = sprintf('Time lapsed: %.2f', toc(t0));
        disp(msg);
        
        errors = [errors; double(max(abs(y_kp1 - y_km1)))];
        
        y_km1 = y_kp1;
        k = k+1;
    end
    
    msg = sprintf('Time lapsed: %.2f', toc(t0_));
    disp(msg);
    
    sol = y_kp1';
end