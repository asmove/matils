function coord_string = vec2str(vec)
    coord_string = '';
    for i = 1:length(vec)
        coord_string = [coord_string, '%+1.4f'];
        if(i ~= length(vec))
            coord_string = [coord_string, ', '];
        end
    end

end
