clear all
close all
clc

multiplots = [];

xs = (-2:0.01:2)';
degrees = 2:10;

msg = 'Calculating saturation signal.';
wb = my_waitbar('');

j = 1;
n_total = length(xs)*length(degrees);
for degree = degrees
    wb = wb.change_title(sprintf([msg, ' - Degree %s'], num2str(degree)));
    
    vals = [];
    for i = 1:length(xs)
        x = xs(i);
        val = poly_sat(x, 1, degree);
        vals = [vals; val];
    
        wb.update_waitbar(i + (j-1)*length(degrees), n_total);
    end
    multiplots = [multiplots, vals];
    
    j = j + 1;
end

legends = cellfun(@num2str, num2cell(degrees), 'UniformOutput', false);
markers = {'-', '--', '.-', '*-', 's-', '^-', 'v-', 'o-', 'k-'};

plot_config.titles = {'Harmonic'};
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'$y(t)$'};
plot_config.grid_size = [1, 1];
plot_config.legends = legends;
plot_config.pos_multiplots = ones(length(degrees)-1, 1);
plot_config.markers = markers;

ys = {multiplots(:, 1), multiplots(:, 2:end)};

hfig = my_plot(xs, ys, plot_config);

fontsize_handles = findall(gcf,'-property','FontSize');
set(fontsize_handles,'FontSize', 12);

filepath = '../imgs/';
img_path = 'polysat';
saveas(hfig, [filepath, img_path, '.eps'], 'epsc');
