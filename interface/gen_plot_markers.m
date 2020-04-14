function markers = gen_plot_markers(num)
    lines = {'.', 's', '*', 'o', ...
         'd', 'p', '+', '^', 'v', 'h', ...
         '>', '<', 'x'};
    traces = {'-', '--', ':', ''};
    colors = {'b', 'c', 'r', 'g', 'w', 'k', 'm'};

    markers = {};
    acc = 0;

    for trace_ = traces
        for line_ = lines
            for color_ = colors
                markers{end+1} = [color_{1}, line_{1}, trace_{1}];
                acc = acc + 1;
                
                if(acc == num)
                    return;
                end
            end
        end
    end
    
end