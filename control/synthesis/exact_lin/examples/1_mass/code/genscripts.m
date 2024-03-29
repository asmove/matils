function [] = genscripts(sys, ctx, script_struct)
    symbs = sys.descrip.syms;
    vals = sys.descrip.model_params;

    % Read buffer
    nchar = 100000;
    
    bdclose all;
    open_system(ctx.model_path);
    sf = Simulink.Root;
    
    paths = script_struct.paths;
    
    for i = 1:length(paths)
        paths_i = paths{i};
        
        block = sf.find('Path', paths_i, '-isa', 'Stateflow.EMChart');
        
        expr_sym = script_struct.expr_syms{i};
        output = script_struct.Outputs{i};
        vars_i = script_struct.vars{i};
        fun_name = script_struct.fun_names{i};
        expr_sym = subs(script_struct.expr_syms{i}, symbs, vals);
        
        a = matlabFunction(expr_sym, 'File', fun_name, 'Vars', vars_i, 'Outputs', output);
        
        fname = [fun_name, '.m'];
        file_handle = fopen(fname, 'r');
        
        f_call = fgets(file_handle, nchar);
        script_body = f_call;
        
        tline = fgets(file_handle, nchar);
        
        while(strcmp(tline(1), '%'))
            tline = fgets(file_handle, nchar);
        end
        
        tline = fgets(file_handle, nchar);
        while(tline ~= -1)
            script_body = [script_body newline tline];
            tline = fgets(file_handle, nchar);
        end
        
        script_body = [script_body newline 'end'];
        
        fclose(file_handle);
        delete(fname);
        
        file_handle = fopen(fname, 'w');
        fprintf(file_handle, '%s', script_body);    
        fclose(file_handle);
        
        block.Script = script_body;
        delete(fname);
    end
    
    save_system(ctx.model_path, [],'OverwriteIfChangedOnDisk',true);
    close_system(ctx.model_path);
end
    
