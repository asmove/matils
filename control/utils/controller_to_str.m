function K_str = controller_to_str(K, is_bracketed_index, has_semicolon)
% Description: Generates a controller code for copy pasting it into
% controller
% Input: 
% - K                  [array  ]: Double array 
% - is_bracketed_index [boolean]: Parenthesis or bracket indexing
% - has_semicolon      [boolean]: semicolon at the end
% Output: 
% - K_str              [string ]: States, controller and control law in
% a string

    K_str = '';
    [m, n] = size(K);
    
    K_sym = sym('K_', [m, n]);
    x_sym = sym('x_', [n, 1]);
    
    open_b = terop(is_bracketed_index, '[', ')');
    close_b = terop(is_bracketed_index, ']', ')');
    ending = terop(has_semicolon, ';', '');
    
    % States into string
    for p = 1:n
        x_i = char(x_sym(p));
        
        idx = [open_b, num2str(p), close_b];
        
        x_i = [x_i, ' = x' idx ending];
        
        K_str = [K_str newline x_i];
    end
    
    K_str = [K_str newline];
    
    % Transform controller matrix into string
    for p = 1:m
        for q = 1:n
            K_ij = char(K_sym(p, q));
            K_ij = [K_ij, ' = ', num2str(K(p, q))];
            K_str = [K_str newline K_ij ending];
        end
    end
    
    K_str = [K_str newline];
    
    % Controller string
    for p = 1:m
        K_str_i = ['u_' num2str(p) ' = '];
        
        for q = 1:n
            K_ij = K_sym(p, q);
            x_i = x_sym(q);
            
            K_ij_char = sym(K_ij);
            Kij_xi = char(K_ij*x_i);
            
            mid_term = '-';
            
            K_str_i = [K_str_i mid_term Kij_xi];
        end
        
        K_str = [K_str newline K_str_i];
    end
end