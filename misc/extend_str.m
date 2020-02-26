function repeat_str = extend_str(snippet, num)
    repeat_str = [];
    for i = 1:num
        repeat_str = [repeat_str, snippet];
    end
end