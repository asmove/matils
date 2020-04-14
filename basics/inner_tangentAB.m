function [B_1, B_2, C_1, C_2, lambda, line0, line1] = ...
        inner_tangentAB(center_A, center_B, r0, r1)
    d01 = norm(center_A - center_B);

    alpha_ = r0/(r0 + r1);

    d0 = alpha_*d01;
    d1 = (1 - alpha_)*d01;

    l0 = sqrt(d0^2 - r0^2);
    l1 = sqrt(d1^2 - r1^2);

    ODC = atan2(r1/d1, l1/d1);
    ODB = atan2(r0/d0, l0/d0);

    D = alpha_*center_B + (1 - alpha_)*center_A;

    DO2_hat = (D - center_B)/norm(D - center_B);
    DO1_hat = (D - center_A)/norm(D - center_A);

    C_1 = D + l0*rot2d(ODC)*DO2_hat;
    C_2 = D + l0*rot2d(-ODC)*DO2_hat;

    B_1 = D + l1*rot2d(-ODB)*DO1_hat;
    B_2 = D + l1*rot2d(ODB)*DO1_hat;
    
    dlambda = 0.01;
    lambda = 0:dlambda:1;
    line0 = B_1 + lambda.*(C_2 - B_1);
    line1 = B_2 + lambda.*(C_1 - B_2);
    line0 = line0';
    line1 = line1';
    lambda = lambda';
end