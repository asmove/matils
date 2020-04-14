close all
clear all
clc

MAX_ITER = 1000;
means = [];
stddevs = [];

for i = 1:MAX_ITER
    acc = [];
    sigma_val = 0.5;
    mean_val = 0;

    tspan = 1:MAX_ITER;

    for j = 1:MAX_ITER
       if(i == 1)
           acc(j, 1) = gaussianrnd(mean_val, sigma_val);
       else
           acc(j, 1) = gaussianrnd(mean_val, sigma_val);
       end
    end
    
    means(i, 1) = mean(acc);
    stddevs(i, 1) = std(acc);
end

my_figure();
plot(1:MAX_ITER, means)

my_figure();
plot(1:MAX_ITER, stddevs)