function H = ctrb_hautus_matrix(A, B, ew)
    n = length(A);
    ew
    H = [ew*eye(n) - A, B];
end