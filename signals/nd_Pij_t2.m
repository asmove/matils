function dPijk = nd_Pij_t2(t, t0, t1, k, Ps)
    [dPijk, Pij] = sym_nd_Pij_t(t0, t1, k, Ps);

    time = symvar(Pij);
    
    dPijk = subs(dPijk, time, t);
end

function [dPijk, Pij] = sym_nd_Pij_t(t0, t1, k, Ps)
    syms time;
    
    n = length(Ps);
    
    Pij = sym(0);
    for i = 1:n
        combni = factorial(n)/(factorial(i)*factorial(n - i));
        Pij = Pij + combni*(((time - t0)/(t1 - t0))^i)*((t1 - time)/(t1 - t0))^(n - i)*Ps{i};
    end
    
    dPijk = vpa(Pij);
    
    for i = 1:k
        dPijk = diff(dPijk, time);
    end
end

