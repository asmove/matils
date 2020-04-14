function x = gaussianrand(meanval, devval)
    y = rand();
    x = meanval + sqrt(2)*devval*erfinv(2*y-1);
end

