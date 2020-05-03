function z = uniform(a, b, dim)
    if(nargin == 2)
        dim = 1;
        n = 1;
    else
        n = prod(dim);
        z = zeros(n, 1);
    end
    
    for i = 1:n
        z(i) = a + (b-a)*rand();
    end
    
    if(length(dim) ~= 1)
        z = reshape(z, dim);
    end
end