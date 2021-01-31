function traj = my_line(t, T, A, B)
    traj = A + (t/T)*(B-A);
end