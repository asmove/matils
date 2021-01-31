function [Phi_d, Gamma_d] = delayed_input_linsys(Phi, Gamma, nds)
    len_nd = length(nds);    
    [n, m] = size(Gamma);
    
    if(len_nd ~= m)
        msg = sprintf('nds vector must have length %d!', len_nd);
        error(msg);
    end
    
    Phi_1 = Phi;
    phi_d = [];
    Gamma_d = zeros(n, m);
    aux_Gamma_d = [];
    
    for i = 1:len_nd
        nd_i = nds(i);
        
        % Transition matrices
        phi_gamma_d = [Gamma(:, i), zeros(n, nd_i-1)];
        
        Phi_1 = [Phi_1, phi_gamma_d];
        
        % Delay matrices
        phi_d_i = [zeros(nd_i-1, 1) eye(nd_i-1); zeros(1, nd_i)];
        
        phi_d = blkdiag(phi_d, phi_d_i);
        
        aux_gamma = canon_Rn(nd_i, nd_i);
        
        aux_Gamma_d = blkdiag(aux_Gamma_d, aux_gamma);
        
    end
    
    Gamma_d = [Gamma_d; aux_Gamma_d];
    Phi_d = [Phi_1; zeros(sum(nds), n),  phi_d];
end
