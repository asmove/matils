function theta = my_atan2(dy, dx)
    theta = atan2(dy, dx);
    
    if(theta < 0)
        theta = 2*pi + theta;
    end
end