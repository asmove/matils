function [mult, exp] = exp_mantissa(num)
    exp_approx = num/log(10);
    exp = floor(exp_approx);
    eps_ = exp_approx - exp;
    mult = 10^eps_;
end