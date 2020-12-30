function dP_t = recursive_ndbezier2(t, t0, t1, Ps, nd_degree)
    n = length(Ps);
    dP_t = nd_Pij_t2(t, t0, t1, nd_degree, Ps);
end

