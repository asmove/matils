% function Pijk = nd_Pij_t(t, k, Ps)
%     Pijk = sym_nd_Pij_t(k, Ps);
% 
%     syms time;
%     
%     Pijk = subs(Pijk, time, t);
% end
% 
% function dPijk = sym_nd_Pij_t(k, Ps)
%     syms time;
%     
%     n = length(Ps);
%     
%     Pij = sym(0);
%     for i = 1:n
%         combni = factorial(n)/(factorial(i)*factorial(n - i));
%         Pij = Pij + combni*(time^i)*(1 - time)^(n - i)*Ps{i};
%     end
%         
%     dPijk = Pij;
%     for i = 1:k
%         dPijk = diff(dPijk, time);
%     end
% end

function Pijk = nd_Pij_t(t, i, j, k, Ps)
    if(k == 0)
        Pijk = Pij_t(t, i, j, Ps);
        return;
    
    % Derivatives greater than curve polynomial
    elseif(j == k+1)
        P_i_jm1_k = zeros(size(Ps{1}));
        P_ip1_jm1_k = zeros(size(Ps{1}));
        
        if(i < length(Ps)-1)
            P_i_jm1_km1 = Ps{i};
            P_ip1_jm1_km1 = Ps{i+1};
        else
            P_i_jm1_km1 = Ps{length(Ps)-1};
            P_ip1_jm1_km1 = Ps{length(Ps)};
        end
        
    % Intermediate values
    else
        P_i_jm1_k = nd_Pij_t(t, i, j-1, k, Ps);
        P_ip1_jm1_k = nd_Pij_t(t, i+1, j-1, k, Ps);
        
        P_i_jm1_km1 = nd_Pij_t(t, i, j-1, k-1, Ps);
        P_ip1_jm1_km1 = nd_Pij_t(t, i+1, j-1, k-1, Ps);
    end
    
    Pijk = (1 - t)*P_i_jm1_k + t*P_ip1_jm1_k + ...
           k*(P_ip1_jm1_km1 - P_i_jm1_km1);
end
