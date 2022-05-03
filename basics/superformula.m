function radius = superformula(theta, amplitudes, exponents)
    a = amplitudes(1);
    b = amplitudes(2);
    
    m = exponents(1);
    
    n_1 = exponents(2);
    n_2 = exponents(3);
    n_3 = exponents(4);
    
    radius = (abs(cos(m*theta/4)/a)^n_2 + abs(sin(m*theta/4)/b)^n_3)^(-1/n_1);
end
