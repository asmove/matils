function xks = pwm_signals(k, alpha_, T, A, b, u_p, u_m, x_0)
    xks = [];
    x_k = x_0;
    
    k = 2*k;
    beta_ = 1 - alpha_;
    
    wb = my_waitbar('Loading states');
    
    for i = 1:k
        if(mod(i, 2) == 0)
            x_k1 = states_k1(beta_*T, A, b, u_m, x_k);
        else
            x_k1 = states_k1(alpha_*T, A, b, u_p, x_k);
        end
        
        x_k = x_k1;
        xks = [xks; x_k'];
    
        wb.update_waitbar(i, k);
    end
    
    wb.close_window();
end