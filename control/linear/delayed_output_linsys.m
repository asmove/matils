function [Phi_d, C_d] = delayed_output_linsys(Phi, C, nds)
    [Phi_d_T, C_d_T] = delayed_input_linsys(Phi', C', nds);

    Phi_d = Phi_d_T';
    C_d = C_d_T.';
end

