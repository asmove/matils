function obstacle = buildObstacle(center, amplitudes, exponents, c0, d0, exponent)
    obstacle.amplitudes = amplitudes;
    obstacle.exponents = exponents;
    obstacle.center = center;
    
    obstacle.c0 = c0;
    obstacle.d0 = d0;
    obstacle.exponent = exponent;
end