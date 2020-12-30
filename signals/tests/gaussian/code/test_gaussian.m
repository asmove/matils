close all
clear all
clc

rand_funcs = {@() randn();
              @() normrnd(0, 1);
              @() gaussianrnd(0, 1)};

MAX_ITER = 1000;
stats_info = {};

for k = 1:length(rand_funcs)
    means = [];
    stddevs = [];
    acc = [];
    
    rand_func = rand_funcs{k};
    for i = 1:MAX_ITER
        
        acc = [];
        tspan = 1:i;
        for j = tspan
            acc = [acc; rand_func()];
        end

        means = [means; mean(acc)];
        stddevs = [stddevs; std(acc)];
    end
    
    stats_info{end+1} = {means, stddevs};
end

plot_config.titles = {'Function mean', 'Function standard deviation'};
plot_config.xlabels = {'Sample pool', 'Sample pool'};
plot_config.ylabels = {'Value $[ \, ]$', 'Value $[ \, ]$'};
plot_config.grid_size = [1, 2];
plot_config.legends = {{'$\mathtt{randn(\cdot)}$', ...
                       '$\mathtt{normrand(\cdot)}$', ...
                       '$\mathtt{gaussianrand(\cdot)}$'}, ...
                       {'$\mathtt{randn(\cdot)}$', ...
                        '$\mathtt{normrand(\cdot)}$', ...
                        '$\mathtt{gaussianrand(\cdot)}$'}};
plot_config.pos_multiplots = [1 1 2 2];
plot_config.markers = {{'b.', 'k.', 'r.'}, ...
                       {'b.', 'k.', 'r.'}};

ys = {[stats_info{1}{1}, stats_info{1}{2}], ...
      [[stats_info{2}{1}, stats_info{3}{1}], ...
       [stats_info{2}{2}, stats_info{3}{2}]]};

x = (1:MAX_ITER)';
[hfig, axs] = my_plot(x, ys, plot_config);

axis(axs{1}{1}, 'square');
axis(axs{1}{2}, 'square');

axs{1}{1}.XAxis.FontSize = 15;
axs{1}{1}.YAxis.FontSize = 15;
axs{1}{1}.TitleFontSizeMultiplier = 1.5;
axs{1}{1}.Legend.FontSize = 15;
axs{1}{1}.Legend.Location = 'best';

axs{1}{2}.XAxis.FontSize = 15;
axs{1}{2}.YAxis.FontSize = 15;
axs{1}{2}.TitleFontSizeMultiplier = 1.5;
axs{1}{2}.Legend.FontSize = 15;
axs{1}{2}.Legend.Location = 'best';

filepath = '../imgs/';
img_path = 'gaussian_noise';
saveas(hfig, [filepath, img_path, '.eps'], 'epsc');
