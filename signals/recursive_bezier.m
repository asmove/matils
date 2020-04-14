function P_t = recursive_bezier(t, Ps)
    n = length(Ps);
    P_t = Pij_t(t, 1, n+1, Ps);
end

