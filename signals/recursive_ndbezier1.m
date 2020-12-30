function dP_t = recursive_ndbezier1(t, Ps, nd_degree)
    n = length(Ps);
    dP_t = nd_Pij_t1(t, 1, n, nd_degree, Ps);
end

