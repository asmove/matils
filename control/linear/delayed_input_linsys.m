function [Phi_d, Gamma_d] = delayed_input_linsys(Phi, Gamma, nds)
    len_nd = length(nds);    
    [n, m] = size(Gamma);
    
    if(len_nd ~= m)
        msg = sprintf('nds vector must have length %d!', len_nd);
        error(msg);
    end
    
    Phi_1 = Phi;
    phi_d = [];
    
    Gamma_d = [];
    for i = 1:m
        nds_i = nds(i);

        gamma_i = terop(nds_i == 0, Gamma(:, i), zeros(n, 1));
        Gamma_d = [Gamma_d, gamma_i];
    end

    aux_Gamma_d = [];
    
    for i = 1:len_nd
        nd_i = nds(i);
        
        if(nd_i == 0)
            % Transition matrix
            phi_gamma_d = [];            
            phi_d_i = [];
            aux_gamma = [];
            
        else
            % Transition matrix
            phi_gamma_d = [Gamma(:, i), zeros(n, nd_i-1)];

            % Transition delay matrices
            phi_d_i = [zeros(nd_i-1, 1) eye(nd_i-1); zeros(1, nd_i)];
            
            % Input delay matrices
            aux_gamma = canon_Rn(nd_i, nd_i);
        end
        
        phi_d = blkdiag(phi_d, phi_d_i);
        Phi_1 = [Phi_1, phi_gamma_d];
        aux_Gamma_d = blkdiag(aux_Gamma_d, aux_gamma);
    end
    
    
    Gamma_d = [Gamma_d; aux_Gamma_d];
    Phi_d = [Phi_1; zeros(sum(nds), n),  phi_d];
end
