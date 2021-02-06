function H = ctrb_hautus_matrix(A, B, ew)
    n = length(A);
    H = [ew*eye(n) - A, B];
end