function idxs = find_index(superset, subset)
    idxs = [];
    
    for i = 1:length(subset)
        idx = find(subset(i) == superset);
        
        if(isempty(idx))
            continue;
        elseif(length(idx) ~= 1)
            error('Length must be equal 1!');
        end
            
        idxs = [idxs; idx];
    end
end