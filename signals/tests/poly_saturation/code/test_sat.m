clear all
close all
clc

multiplots = [];

xspan = (-2:0.01:2)';
degrees = 0:10;

msg = 'Calculating saturation signal.';
wb = my_waitbar('');

% switch_funcs = {@(x) sign(x), ...
%                 @(x) sat_sign(x, 1), ...
%                 @(x, degree) poly_sat(x, 1, degree)};

switch_funcs = @(x, degree) poly_sat(x, 1, degree);

n_total = length(xspan)*(length(degrees));

n_degrees = length(degrees);
n_xspan = length(xspan);

j = 1;
acc = 1;

multiplots = zeros(n_xspan, n_degrees);
switch_func = switch_funcs;
    
% Polynomial sign functions
for degree = degrees
    wb_title = sprintf([msg, ' - Degree %s'], num2str(degree));
    wb = wb.change_title(wb_title);

    vals = [];

    for i = 1:length(xspan)
        x = xspan(i);
        val = switch_func(x, degree);
        vals = [vals; val];

        acc = acc + 1;

        wb.update_waitbar(acc, n_total);

    end

    multiplots(:, j) = vals;
    j = j + 1;
end

% % Saturation and sign functions
% wb_title = sprintf([msg, ' - Sign and saturation']);
% wb = wb.change_title(wb_title);
% 
% vals = [];
% 
% for i = 1:length(xspan)
%     x = xspan(i);
%     val = switch_func(x);
%     vals = [vals; val];
% 
%     acc = acc + 1;
% 
%     wb.update_waitbar(acc, n_total);
% end
% 
% multiplots(:, j) = vals;
% j = j + 1;

legends = cellfun(@num2str, num2cell(degrees), 'UniformOutput', false);
markers = {'-', '--', '-.', '-*', '-s', '-^', ...
           'v-', '-o', '-k', '-b', '-m', ''};

legends_ = {};
for i = 1:length(legends) 
    legend_ = legends(i);
    legends_{end+1} = ['Polynomial - ', legend_{1}];
end
legends = legends_;
       
plot_config.titles = {''};
plot_config.xlabels = {'t [s]'};
plot_config.ylabels = {'$y(t)$'};
plot_config.grid_size = [1, 1];
plot_config.legends = legends;
plot_config.pos_multiplots = ones(1, length(degrees) - 1);
plot_config.markers = repeat_str('--', length(degrees));

ys = {multiplots(:, 1), multiplots(:, 2:end)};
hfig = my_plot(xspan, ys, plot_config);

axis([[-2 2 -2 2]]);
axis square

fontsize_handles = findall(gcf,'-property','FontSize');
set(fontsize_handles,'FontSize', 12);

filepath = '../imgs/';
img_path = 'polysat';
saveas(hfig, [filepath, img_path, '.eps'], 'epsc');
