function [Phi_d, Gamma_d, C_d, D_d] = delay_io(Phi, Gamma, C, D, nds_i, nds_o)
    if(sum(sum(D)) ~= 0)
        error('Error: Not implemented for D ~= 0');
    end
    
    [~, m] = size(Gamma);
    [p, ~] = size(C);
    
    if(length(nds_i) ~= m)
        error('Error: Number of input delays MUST have the same number of columns as u');
    end
    
    if(length(nds_o) ~= p)
        error('Error: Number of output delays MUST have the same number of rows as u')
    end
    
    s_nd_i = sum(nds_i);
    s_nd_o = sum(nds_o);
    
    [Phi_d, Gamma_d] = delayed_input_linsys(Phi, Gamma, nds_i);

    C_d = [C, zeros(p, s_nd_i)];

    [Phi_d, C_d] = delayed_output_linsys(Phi_d, C_d, nds_o);
    
    Gamma_d = [Gamma_d; zeros(s_nd_o, m)];

    D_d = D;
end