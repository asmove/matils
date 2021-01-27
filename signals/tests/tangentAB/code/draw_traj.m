function hfig = draw_traj(path)
    hfig = my_figure();

    n_p = 1;
    
    FontSize = 25;
    LineWidth = 2;
    
    A = path.A;
    B = path.B;

    C_0 = path.C_0;
    C_1 = path.C_1;

    D_0 = path.D_0;
    D_1 = path.D_1;

    circA = path.circA;
    circB = path.circB;

    line0 = path.line0;
    line1 = path.line1;

    phi_0 = path.phi_0;
    phi_1 = path.phi_1;

    center_0 = path.center_0;
    center_1 = path.center_1;

    plot(A(1), A(2), 'k*');
    hold on;
    plot(B(1), B(2), 'k*');
    hold on;

    trajectory = path.trajectory;

    path0 = trajectory{1};
    plot(path0(:, 1), path0(:, 2), 'k', ...
         'LineWidth', LineWidth);

    path01 = trajectory{2};
    plot(path01(:, 1), path01(:, 2), 'k', ...
         'LineWidth', LineWidth);

    path1 = trajectory{3};
    plot(path1(:, 1), path1(:, 2), 'k', ...
         'LineWidth', LineWidth);

    plot(line0(:, 1), line0(:, 2), 'b--');
    hold on;
    plot(line1(:, 1), line1(:, 2), 'b--');
    hold on;

    plot(circA(:, 1), circA(:, 2), 'r--');
    hold on;
    plot(circB(:, 1), circB(:, 2), 'r--');
    hold on;

    plot(center_0(1), center_0(2), 'kx');
    hold on;
    plot(center_1(1), center_1(2), 'kx');
    hold on;

    plot(path.dest_0(1), path.dest_0(2), 'ks');
    text(path.dest_0(1), path.dest_0(2), ...
         '$\leftarrow \, C$', 'FontSize', FontSize);
    hold on;

    plot(path.orig_1(1), path.orig_1(2), 'ks');
    hD = text(path.orig_1(1), path.orig_1(2), ...
         '$\leftarrow \, D$', 'FontSize', FontSize);
    hold on;
    
    text(A(1), A(2), '$\leftarrow A$', ...
                     'FontSize', FontSize);

    hB = text(B(1), B(2), '$B \, \rightarrow$', ...
                          'FontSize', FontSize);
    
    text(center_0(1), center_0(2), ...
         '$\leftarrow O_0$', 'FontSize', FontSize);

    text(center_1(1), center_1(2), ...
         '$\leftarrow O_1$', 'FontSize', FontSize);

    hold off;
    
    ax = gca;
    ax.FontSize = 25;
    
    axis equal
    axis tight
    
    % Adjust B text
    pos = hB.Position;
    
    Px = pos(1);
    Py = pos(2);
    
    w = hB.Extent(3);
    h = hB.Extent(4);
    
    scaler = 1.2;
    
    set(hB, 'Position', [Px - scaler*w, Py, 0]);
    
    % Adjust D text
    pos = hD.Position;
    
    Px = pos(1);
    Py = pos(2);
    
    w = hD.Extent(3);
    h = hD.Extent(4);
    
    eps_scaler = 1e-1;
    
    set(hD, 'Position', [Px + eps_scaler*w, Py, 0]);
end