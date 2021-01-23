function [phi_aug, gamma_aug, C_aug] = pwm_model(A, B, C, Ctilde, alpha_, Tpwm, Ts)
    [phi, gamma] = ss_PWM(alpha_, A, B, Tpwm, Ts);

    [n_Ctilde, ~] = size(Ctilde);
    [n_C, ~] = size(C);

    [~, m] = size(gamma);
    n = length(A);

    phi_aug = double([phi, zeros(n, n_Ctilde);...
                      Ctilde, zeros(n_Ctilde, n_Ctilde)]);

    gamma_aug = double([gamma;...
                        zeros(n_Ctilde, m)]);

    C_aug = double([C, zeros(n_C, n_Ctilde)]);
end
