function [] = gen_script_model(sys, model_name, options)
    q = sys.kin.q;
    qp = sys.kin.qp;
    p = sys.kin.p{end};
    u = sys.descrip.u;

    Z = sys.dyn.Z;
    u = sys.descrip.u;
    h = sys.dyn.h;
    C = sys.kin.C;
    A = sys.kin.A;
    dA = dmatdt(A, q, C*p);
    dC = dmatdt(C, q, C*p);
    M = sys.dyn.M;
    
    if(elem_isnull(sys.descrip.Fq))
        Q = - sys.dyn.nu - sys.dyn.g - sys.dyn.f_b - sys.dyn.f_k; 
        expr_syms = {C*p; C; M; - h};
        vars = {{[q; p]}, {[q; p]}, {[q; p]}, {[q; p]}};
    else
        Q = sys.dyn.U*sys.descrip.u - sys.dyn.nu - sys.dyn.g - sys.dyn.f_b - sys.dyn.f_k; 
        expr_syms = {C*p; C; M; Z*u - h};
        
        vars = {{[q; p]}, {[q; p]}, {[q; p]}, {[q; p], u}};
    end
    
    for j = 1:length(expr_syms)
        
        expr_sym = expr_syms(j);
        expr_sym = expr_sym{1};
        
        if(isempty(expr_sym))
            expr_syms{j} = zeros(1);
        end
    end
    
    Outputs = {{'qp'}, {'C'}, {'M_matrix'}, {'fs'}};
    
    paths = {[model_name, '/Plant/Dynamic system/Auxiliary_matrices/C_p'], ...
             [model_name, '/Plant/Dynamic system/Auxiliary_matrices/C_matrix'], ...
             [model_name, '/Plant/Dynamic system/Mass_block/mass_tensor'], ...
             [model_name, '/Plant/Dynamic system/Efforts/Constrained_efforts']};
    
    fun_names = {'KinematicVector', 'ConstraintMatrix', 'Mass_matrix', 'ConstrainedEffort'};

    symbs = sys.descrip.syms;
    vals = sys.descrip.model_params;

    % Read buffer
    nchar = 100000;

    open_system(model_name);
    sf = Simulink.Root;

    for i = 1:length(paths)
        
        paths_i = paths{i};
        expr_sym = expr_syms{i};
        output = Outputs{i};
        vars_i = vars{i};
        fun_name = fun_names{i};
        expr_sym = subs(expr_sym, symbs, vals);
        
        load_simblock(paths_i, fun_name, expr_sym, vars_i, output);
    end
    
    save_system(model_name, [],'OverwriteIfChangedOnDisk',true);
    close_system(model_name);
end
    
