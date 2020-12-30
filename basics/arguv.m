function theta = arguv(u, v)
    if((norm(u) == 0) || (norm(v) == 0))
        error('Vectors u and v may not be null!');
    end
    
    EPS_ = 1e-5;
    
    norm_u = norm(u);
    norm_v = norm(v);
    dot_uv = dot(u, v);
    
    cos_theta = dot_uv/((norm_u)*(norm_v));
    proj_uv = norm_v*cos_theta*u/norm_u;
    w = v - proj_uv;

    norm_w = norm(w);
    sin_theta = norm_w/norm_v;

    theta = atan2(sin_theta, cos_theta);
end