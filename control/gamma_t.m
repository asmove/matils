function gamma_ = gamma_t(t, A, b)
    syms time real;
    n = length(A);
    
    gamma_ = int(expm(A*time)*b, 0, t);

    if(isempty(symvar(gamma_)))
        gamma_ = double(gamma_);
    else
        gamma_ = vpa(gamma_);
    end
end