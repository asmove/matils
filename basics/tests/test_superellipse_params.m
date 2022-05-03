clear all
close all
clc

run('textInterpretersToLatex');
run('load_superparams');
keys_ = keys(params);

amplitudes = [1, 1];

params_keys = keys(params);

center = [0; 0];
orientation = 0;

thetas = 0:0.001:2*pi;

for param_key = string(params_keys)
    param_struct = params(char(param_key));
    exponents = zeros(length(keys_));
    params_compl_keys = params_keys(params_keys ~= param_key);
    
    compl_val_arr = [];
    for params_compl_key = params_compl_keys
        param_compl_key = params(char(params_compl_key));
        
        exponents(param_compl_key('position')) = param_compl_key('default');
        compl_val_arr = [compl_val_arr, param_compl_key('default')];
    
    
    end
    
    hfig = my_figure();
    
    for param_value = param_struct('tests')
        exponents(param_struct('position')) = param_value;
        
        radius_fun = @(phase) superformula(phase, amplitudes, exponents);

        coords = [];

        for theta = thetas
            coord = radialSurf(center, theta, radius_fun)';
            coords = [coords; coord];
        end
        
        legend_name = sprintf('%.2f', param_value);
        plot(coords(:, 1), coords(:, 2), ...
            'DisplayName', legend_name);
        hold on;
    end
    
    title_string = sprintf('[$%s$, $%s$, $%s$] = [%.2f, %.2f, %.2f]', ...
                  char(params_compl_keys(1)), ...
                  char(params_compl_keys(2)), ...
                  char(params_compl_keys(3)), ...
                  compl_val_arr(1), ...
                  compl_val_arr(2), ...
                  compl_val_arr(3));
    
    title(title_string);
    
    hold off
    axis equal
    axis square
    grid
    legend show
    
    children = get(gcf, 'Children');
    
    title(children(1), sprintf('$%s$', param_key), 'Interpreter', 'latex')
    
    filename = ['var_', char(param_key), '.eps'];
    root_path = [pwd, '/imgs/'];
    imgs_path = [root_path, '/', filename];
    
    saveas(hfig, imgs_path, 'epsc');
end