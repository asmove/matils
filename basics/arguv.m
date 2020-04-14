function theta = arguv(u, v)
    norm_u = norm(u);
    norm_v = norm(v);
    dot_uv = dot(u, v);
    
    theta = acos(dot_uv/(norm_u*norm_v));
end