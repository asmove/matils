function simOut = sim_block_diagram(model_name, options)
    
    if(nargin == 1)
        options.LoggingToFile = 'on';
        options.LoggingFileName = 'simOut';
    end
    
    load_system(model_name);
    simMode = get_param(model_name, 'SimulationMode');
    set_param(model_name, 'SimulationMode', 'normal');

    cs = getActiveConfigSet(model_name);
    mdl_cs = cs.copy;
    
    save_system();
    
    options.SaveState = 'on';
    options.StateSaveName = 'xoutNew';
    options.SaveOutput = 'on';
    options.OutputSaveName = 'youtNew';
    
    t0 = tic();
    simOut = sim(model_name, options);
    toc(t0);
    
    close_system(model_name);
    
    % Supress values close to zero
    THRES = 1e-5;
    
    fields = fieldnames(simOut);
    
    for field = fields
        if(isfield(simOut, 'signal'))
            vec = simOut(field).signals.values;
            
            vec_supressed = suppress_zero_fluctuation(vec, THRES);
            simOut(field).signals.values = vec_supressed;
        end
    end
    
end