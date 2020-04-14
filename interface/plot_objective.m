function plot_objective(t, x)
    plot_config.titles = {'Objective function'};
    plot_config.xlabels = {'Iterations'};
    plot_config.ylabels = {'$J(t, x)$'};
    plot_config.grid_size = [1, 1];
    
    hfig = my_plot(t, x, plot);
end