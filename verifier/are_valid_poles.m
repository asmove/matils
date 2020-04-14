function  [id_imags, id_conj_imags] = are_valid_poles(eigs)
    [id_imags, id_conj_imags] = find_conjs(eigs);
    
    % Verify inconsistencies on eigenvalues:
    % - Complex eigenvalues must have respective conjugate;
    for i = 1:length(id_imags)
        if(isempty(id_conj_imags{i}))
            error('There MUST be the complex and conjugate complex numbers both');
        end
    end
end