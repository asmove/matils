function dP_t = recursive_ndbezier(t, Ps, nd_degree)
    n = length(Ps);
    
    dP_t = nd_Pij_t(t, 1, n, nd_degree, Ps);
    %dP_t = nd_Pij_t(t, nd_degree, Ps);
end

