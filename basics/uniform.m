function z = uniform(a, b, dim)
    n = prod(dim);
    z = zeros(n, 1);
    
    for i = 1:n
        z(i) = a + (b-a)*rand();
    end
    
    if(length(dim) ~= 1)
        z = reshape(z, dim);
    end
end