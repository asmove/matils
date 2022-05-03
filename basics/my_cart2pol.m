function [th, R] = my_cart2pol(x, y, center)
    coords = [x; y] - center;
    
    [th,R] = cart2pol(coords(1), coords(2));
end