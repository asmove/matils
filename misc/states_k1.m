function x_k1 = states_k1(t, A, b, u, x_k)
    gamma_ = gamma_t(t, A, b);
    x_k1 = expm(A*t)*x_k + gamma_*u;
    
    if(isempty(symvar(x_k1)))
        x_k1 = double(x_k1);
    else
        x_k1 = vpa(x_k1);
    end
end
