function Pij = Pij_t(t, i, j, Ps)
    
    n = length(Ps);
    
    if(j == 1)
        if(i < n-1)
            P_i_jm1 = Ps{i};
            P_ip1_jm1 = Ps{i+1};
        else
            P_i_jm1 = Ps{n-1};
            P_ip1_jm1 = Ps{n};
        end
    else
        P_i_jm1 = Pij_t(t, i, j-1, Ps);
        P_ip1_jm1 = Pij_t(t, i+1, j-1, Ps);
    end
    
    Pij = (1 - t)*P_i_jm1 + t*P_ip1_jm1;
end