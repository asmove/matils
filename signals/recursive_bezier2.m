function Pij = recursive_bezier2(t, Ps)
    syms time;
    
    n = length(Ps) - 1;
    
    Pij = sym(0);
    for i = 1:(n+1)
        % Adequates matlab indexing
        j = i - 1;
        combni = factorial(n)/(factorial(j)*factorial(n - j));
        Bi = Ps{i};
        
        Pij = Pij + combni*(time^j)*(1 - time)^(n - j)*Bi;
    end
    
    Pij = subs(Pij, time, t);
end