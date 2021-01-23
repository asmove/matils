function [eigs, is_cont] = ctrb_hautus(sys)
    is_cont = [];
    
    eigs = eig(sys.a);
    n = length(eigs);
    
    A = sys.a;
    B = sys.b;
    
    for i = 1:n
        ew = eigs(i);
        
        H = ctrb_hautus_matrix(A, B, ew);
        
        is_cont(i) = rank(H) == n;
    end
end

