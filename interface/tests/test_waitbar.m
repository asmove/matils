fig_handlers = findall(0,'type','figure','tag','TMWWaitbar');
delete(fig_handlers);

wb1 = my_waitbar('Waitbar 1');
wb2 = my_waitbar('Waitbar 2');

wb1.wb.UserData
wb2.wb.UserData

wb1.find_handle()
wb2.find_handle()

wb1.close_window()
wb2.close_window()


