function val = pwm_signal(t, max_val, min_val, alpha, T)
    persistent t0;
    if(isempty(t0))
        t0 = 0;
    end
    
    if(t == 0)
        t0 = 0;
    end

    if(t - t0 > T)
        t0 = t;
    end

    t_i = t - t0;
    
    if(t_i < alpha*T)
        val = max_val;
    else
        val = min_val;
    end
end