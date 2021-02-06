function linsys =  lin_sys(sys, x_WP, u_WP, Ts)
    % States and control variables
    if(isempty(sys.descrip.u))
        sys.descrip.u = sym('u');
    end
    
    states = sys.dyn.states;
    u = sys.descrip.u;
    
    linvars = [states; u];
    WP = [x_WP; u_WP];
    
    % Workint points
    linsys.x_WP = x_WP;
    linsys.u_WP = u_WP;
    
    linsys.y_WP = subs(sys.descrip.y, linvars, WP);
    
    % Matrices A, B, C and D for each working-point
    linsys.linvars = sym('u%d', size(sys.dyn.states));
    
    p = sys.kin.p{end};
    C = sys.kin.C;
    H = sys.dyn.H;
    h = sys.dyn.h;
    Z = sys.dyn.Z;
    
    n = length(size(H));
    Hsym = sym('H_', size(H));
    
    Hsym_flatten = reshape(Hsym, [n^2, 1]);
    invHsym_flatten = reshape(inv(Hsym), [n^2, 1]);
    H_flatten = reshape(H, [n^2, 1]);
    invH_flatten = my_subs(invHsym_flatten, Hsym_flatten, H_flatten);
    invH = reshape(invH_flatten, [n, n]);
    
    [n_q, n_u] = size(sys.dyn.Z);
    
    f = [C*p; -invH*h];
    G = [zeros(n_q, n_u); invH*Z];
    
    sys.dyn.f = f;
    sys.dyn.G = G;
    y = sys.descrip.y;
    
    % Linearization matrices (arbitrary)
    linsys.A0 = jacobian(f + G*u, states);
    linsys.B0 = jacobian(f + G*u, u);
    linsys.C0 = jacobian(y, states);
    linsys.D0 = jacobian(y, u);
        
    % Matrices on the provided working-point
    A = subs(linsys.A0, linvars, WP);
    B = subs(linsys.B0, linvars, WP);
    C = subs(linsys.C0, linvars, WP);
    D = subs(linsys.D0, linvars, WP);
    
    % Working point linearization points
    linsys.A_WP = simplify(A);
    linsys.B_WP = simplify(B);
    linsys.C_WP = simplify(C);
    linsys.D_WP = simplify(D);
    
    
    linsys.A = double(subs(linsys.A_WP, sys.descrip.syms, ...
                                        sys.descrip.model_params));
    linsys.B = double(subs(linsys.B_WP, sys.descrip.syms, ...
                                        sys.descrip.model_params));
    linsys.C = double(subs(linsys.C_WP, sys.descrip.syms, ...
                                        sys.descrip.model_params));
    linsys.D = double(subs(linsys.D_WP, sys.descrip.syms, ...
                                        sys.descrip.model_params));
            
    % State space representation
    linsys.A
    linsys.B
    linsys.C
    linsys.D
    sys_cont.ss = ss(linsys.A, linsys.B, linsys.C, linsys.D);
    
    % Poles, nulls, controlability and observability
    [sys_cont.nulls, sys_cont.poles, ...
     sys_cont.is_ctrb, sys_cont.is_obsv] = plant_behaviour(sys_cont.ss);
    
    % Discretized system
    sys1_disc.ts = Ts;
    sys1_disc.ss = c2d(sys_cont.ss, Ts, 'zoh');
    
    % POles, zeros and controllability
    [sys1_disc.nulls, ...
     sys1_disc.poles, ...
     sys1_disc.is_ctrb, ...
     sys1_disc.is_obsv] = plant_behaviour(sys1_disc.ss);
     
    linsys.continuous.systems = {sys_cont};
    linsys.discrete.systems = {sys1_disc};
end