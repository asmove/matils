function x = gaussianrnd(meanval, devval)
    x = zeros(length(meanval), 1);
    for i = 1:length(meanval)
        y = rand();
        x(i) = meanval(i) + sqrt(2)*devval*erfinv(2*y-1);
    end
end