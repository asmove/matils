function [phi_Ts, gamma_Ts] = ss_PWM(alpha_, A, B, Tpwm, Ts)
    syms u_p u_m real;
    syms alpha_sym beta_sym real;
    
    % States
    x_k_ = sym('xk_', [length(A), 1]);
    symbs = [alpha_sym; beta_sym];
    
    % 1 period evaluation
    xk_alpha = states_k1(alpha_sym*Tpwm, A, B, u_m, x_k_);
    xk_beta = states_k1(beta_sym*Tpwm, A, B, u_p, xk_alpha);
    
    % Discrete state space representation
    u = [u_m, u_p];
    phi_Tpwm = equationsToMatrix(xk_beta, x_k_);
    gamma_Tpwm = equationsToMatrix(xk_beta, u);
    
    beta_ = 1 - alpha_;  
    vals = [alpha_; beta_];
    
    phi_val = subs(phi_Tpwm, symbs, vals);
    gamma_val = subs(gamma_Tpwm, symbs, vals);
    
    % Multiplicity of PWM and sample period
    n = floor(Ts/Tpwm);
    m = mod(Ts, Tpwm)/Tpwm;
    
    phi_Ts = phi_val^n;
    gamma_Ts = gamma_val;
    
    n_phi = length(phi_val);
    
    summand = eye(n_phi);
    acc = eye(n_phi);
    
    for i = 1:(n-1)
        summand = double(summand*phi_val);
        acc = double(acc + summand);
    end
    
    gamma_Ts = acc*gamma_val;
    
    if(m <= alpha_)
        vals = [m; 0];
    else
        vals = [alpha_; m-alpha_];
    end
    
    phi_m = subs(phi_Tpwm, symbs, vals);
    gamma_m = subs(gamma_Tpwm, symbs, vals);
    
    phi_Ts = phi_m*phi_Ts;
    gamma_Ts = gamma_m + phi_m*gamma_Ts;
end
