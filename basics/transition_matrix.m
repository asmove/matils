function phi_t = transition_matrix(t, A, norm_type)
    if(nargin == 2)
        norm_type = 2;
    end
    
    EPS_ = 1e-5;
    
    i = 1;
    phi_t = eye(length(A));
    phi_prev = sym(phi_t);
    is_precise = false;
    
    while(~is_precise)
        fac_i = factorial(i);
        A_t = A*t;
        phi_t = phi_t + A_t^i/fac_i;
        i = i + 1;
        
        norm_error = norm(phi_t - phi_prev, norm_type);
        if(norm_error < EPS_)
            is_precise = true;
        else
            phi_prev = phi_t;
        end
    end
end