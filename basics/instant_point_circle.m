function t = instant_point_circle(rho_, omega_, phi, center_, P)
    vec_ = (P - center_)/rho_;
    arg_vec = atan2(vec_(2), vec_(1));
    
    if(arg_vec < 0)
        arg_vec = arg_vec + 2*pi; 
    end
    
    t = (1/omega_)*(arg_vec - phi);
end