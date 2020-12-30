function [] = tighten_plot(ax)
    pos = ax.Position;
    ti = ax.TightInset;
    
    ti = [0, 0, 0, 0];
    
    % [left bottom right top]
%     left = pos(1) - ti(1);
%     bottom = pos(2) - ti(2);
%     width = pos(3) - ti(3);
%     height = pos(4) - ti(4);

    left = pos(1);
    bottom = pos(2);
    width = pos(3);
    height = pos(4);

    ax.OuterPosition = [left bottom width height];
end
