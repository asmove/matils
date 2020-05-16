function theta = my_atan2(a, b)
    theta = atan2(a, b);
    
    if(theta < 0)
        theta = 2*pi + theta;
    end
end