function func_val = smoothstep(t, T_begin, T_end, y_begin, y_end, degree)
    delta_T = T_end - T_begin;
    x = (t - T_begin)/delta_T;
    
    func_val = 0;
    
    if((x >= 0)&&(x < 1))
        for k = 0:degree
            comb_1 = nchoosek(degree+k, k);
            comb_2 = nchoosek(2*degree+1, degree-k);
            monome = dsmoothstep_monome(x, k, degree, 0, 1);
            func_val = func_val + monome;
        end
        
        func_val = x^(degree+1)*func_val;
        func_val = y_begin + (y_end - y_begin)*func_val;
    elseif(x>=1)
        func_val = y_end;
    else
        func_val = y_begin;
    end
    func_val = simplify_(func_val);
end
