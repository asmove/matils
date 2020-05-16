function coeffs_ = my_poly(roots)
    syms x;
    
    pol_ = sym(1);
    for i = 1:length(roots)
        pol_ = pol_*(x - roots(i));
    end
    
    coeffs_ = vpa(fliplr(coeffs(expand(pol_))));
end