function [hfig, X, Y, Z] = drawObstacle(hfig, obstacle)
    c0 = obstacle.c0;
    d0 = obstacle.d0;
    exponent = obstacle.exponent;
    
    exponents = obstacle.exponents;
    amplitudes = obstacle.amplitudes;
    
    % radial function 
    radius_fun = @(theta) superformula(theta, amplitudes, exponents);
    
    a = 1/d0;
    b = -1;

    coeffs = c0*linePowerCoeffs(a, b, exponent);

    % Instances plot
    dx = 1e-3;

    n = 50;
    thetas = linspace(0, 2*pi, n);
    ds = linspace(0, d0, n);
    rhos = zeros(1, n);

    nx = length(thetas);
    ny = length(ds);

    wb = my_waitbar('Loading function.');

    Z = zeros(nx, ny);
    TH = zeros(nx, ny);
    RHO = zeros(nx, ny);

    for i = 1:nx
        th_i = thetas(i);
        rhos(i) = radius_fun(th_i);
        rho = rhos(i);

        for j = 1:ny 
            d_i = ds(j);

            if(d_i > d0)
              Z(i, j) = 0;
            else
              Z(i, j) = my_polyval(coeffs, d_i);
            end

            TH(i, j) = th_i;
            RHO(i, j) = rho + d_i;

            wb.update(i*nx + j, nx*ny);
        end
    end

    wb.close_window()

    run('textInterpretersToLatex');
    
    figure(hfig);
    
    [X,Y] = pol2cart(TH, RHO);
    surf(X, Y, Z)

    shading flat

end