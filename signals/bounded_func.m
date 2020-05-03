function [~, is_inbetween] = bounded_func_const(a_sol, degree, T_val, vareps)
    syms T x;
    a_sym = sym('a', [degree, 1]);
    
    pol_val = sym(0);
    for i = 1:degree
        pol_val = pol_val + a_sym(i)*(x/T_val)^i;
    end
    
    pol_val = subs(pol_val, a_sym, a_sol);
    factors = factor(pol_val, 'FactorMode', 'full');
    
    real_roots = [];
    for factor_ = factors
        if(imag(factor_) == 0)
        real_roots = [real_roots, factor_];
        end
    end
    
    max_val = double(subs(pol_val, x, real_roots(1)));
    for i = 2:length(real_roots)
        candidate = double(subs(pol_val, x, real_roots(1)));
        if(candidate > max_val)
            max_val = candidate;
        end
    end
    
    is_inbetween = (max_val > -vareps) || ...
                   (max_val < vareps);
end