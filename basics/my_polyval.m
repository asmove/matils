function val = my_polyval(coeffs, x)
    vec = zeros(1, length(coeffs));
    for i = 1:length(coeffs)
       if(x == 0 && i == 0)
           vec(0) = 0;
       else
           vec(i) = x^(i-1);
       end
    end
    
    val = dot(coeffs, vec);
end