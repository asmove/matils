function [] = clean_vars(except_names)
    vars = whos;

    for i = 1:length(vars)
        var = vars(i);
        name = var.name;


        is_not_except_names = true;

        for j = 1:length(except_names)
            except_name = except_names{j};
            is_not_except_names = is_not_except_names & ~strcmp(name, except_name);
        end

        if(is_not_except_names)
            clear(name);
        end
    end
end