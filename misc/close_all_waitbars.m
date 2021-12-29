function close_all_waitbars()
    delete(findall(0,'type','figure','tag','TMWWaitbar'));
end