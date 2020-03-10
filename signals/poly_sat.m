function val = poly_sat(actual, phi, degree)
    
    if(phi < 0)
        error('Phi must be greater than 0!');
    end
    
    actual_ = (actual + phi)/(2*phi);
    
    val = smoothstep(actual_, 1, -1, 1, degree);
end