function [C_0, C_1, D_0, D_1, ...
          lambda, line0, line1] = ...
        inner_tangentAB(center_0, center_1, r0, r1)
    % Center distances
    d01 = norm(center_0 - center_1);
    
    % Radius relations
    alpha_ = r0/(r0 + r1);
    
    d0 = alpha_*d01;
    d1 = (1 - alpha_)*d01;
    
    % Distance from interception to tangency
    l0 = sqrt(d0^2 - r0^2);
    l1 = sqrt(d1^2 - r1^2);
    
    % Central angles
    OEC = atan2(r0/d0, l0/d0);
    OED = atan2(r1/d1, l1/d1);    
    
    % Interception point
    E = alpha_*center_1 + (1 - alpha_)*center_0;
    
    % Versor from interception point
    EO0_hat = (center_0 - E)/norm(E - center_0);
    EO1_hat = (center_1 - E)/norm(E - center_1);
    
    % Tangency point
    C_0 = E + l0*rot2d(-OEC)*EO0_hat;
    C_1 = E + l0*rot2d(OEC)*EO0_hat;
    D_0 = E + l1*rot2d(OED)*EO1_hat;
    D_1 = E + l1*rot2d(-OED)*EO1_hat;
    
    % Geomtric place
    dlambda = 0.01;
    lambda = 0:dlambda:1;
    
    line0 = C_0 + lambda.*(D_1 - C_0);
    line1 = C_1 + lambda.*(D_0 - C_1);
    
    line0 = line0';
    line1 = line1';
    
    lambda = lambda';
end