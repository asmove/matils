function coeffs = linePowerCoeffs(a, b, n)
    % (ax + b)^n
    coeffs = zeros(1, n+1);
    for i = 0:n 
        coeffs(i+1) = linePowerCoeff(a, b, n, i);
    end
    
    coeffs = fliplr(coeffs);
end

function coeff = linePowerCoeff(a, b, n, i)
    coeff = a^i*b^(n-i)*nchoosek(n, i);
end