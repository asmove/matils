classdef my_waitbar
    properties
        idx = '';
        
        % Mask for message ovre progress bar
        time_mask = '%3d.%s %% - %s [%%/s] [%s - %s - %s]';
        
        % Message on title
        name = '';
        msg = '';
        
        % Simulation time
        t_sim = 0;
        t_real = 0;
        
        % Real time
        t_curr_str = '';
        t_end_str = '';
        t_left_str = '';
        
        % Real time
        t_real_vec = [];
        
        % Real time
        tf = 0;
        tf_real_vec = [];
        
        % Speed(s) of percentage per time
        speed = 0;
        speed_vec = [];
         
        wb = [];
        
        previous_t = 0;
        
        t_prev = 0;
    end
    
    methods
        function obj = set.t_sim(obj, num)
            obj.t_sim = num;
        end
        
        function obj = set.t_real(obj, num)
            obj.t_real = num;
        end
        
        function obj = set.t_curr_str(obj, num)
            obj.t_curr_str = num;
        end
                
        function obj = set.speed(obj, num)
            obj.speed = num;
        end
    
        function obj = my_waitbar(name)
            if(nargin==0)
                obj.name = '';
            else
                obj.name = name;
            end
            
            obj.t_curr_str = datestr(seconds(0), 'HH:MM:SS');
            obj.t_end_str = datestr(seconds(0), 'HH:MM:SS');
            
            obj.msg = sprintf(obj.time_mask, 0, obj.speed, ...
                              obj.t_curr_str, obj.t_end_str);
            
            cancel_callback = 'setappdata(gcbf,''canceling'',1)';
            obj.wb = waitbar(0, obj.msg,  'Name', obj.name, ... 
                             'CreateCancelBtn', cancel_callback);
            
            % Change the Units Poreperty of the figure and all the children
            set(findall(obj.wb),'Units', 'normalized');
            % Change the size of the figure
            set(obj.wb, 'Position', [0.25 0.4 0.3 0.08]);            
                        
            obj.wb.UserData = generate_guid;
            obj.idx = obj.wb.UserData;
            
            screensize = get(0,'ScreenSize');
            
            width = screensize(3);
            height = screensize(4);
            l_pos = uniform(0, width);
            b_pos = uniform(0, height);
            obj.wb.Position = [l_pos, b_pos, obj.wb.Position(3), obj.wb.Position(4)];
            
            % Width of timebar window
            winwidth = 300;
            
             % Height of timebar window
            winheight = 85;
            
            obj.previous_t = tic;
        end
        
        function cancelButtonCallback(hSource, eventdata)
            cancelWaitbar = 1;
        end
        
        function h = find_handle(obj)
            hs = findall(0,'type','figure','tag','TMWWaitbar');
            
            handles = [];
            for i = 1:length(hs)
                unique_id = hs(i).UserData;
                
                if(strcmp(unique_id, obj.idx))
                    h = hs(i);
                    handles = [handles; hs(i)];
                end
            end
            
            if(length(handles) ~= 1)
                warning('There is more than a handle with prescripted ID.');
                error('Handle must be unique!');
            end
        end
        
        function delete(obj)
            % obj is always scalar
            h = obj.find_handle();
            
            if(length(h) == 1)
                delete(h);
            else
                error('There is more than a handle with prescripted ID.');
            end
        end
        
        function obj = change_title(obj, name)
            obj.wb.Name = name;
        end
        
        function [] = update(obj, t, tf)
            dt = toc(uint64(obj.previous_t));
            obj.previous_t = tic;
            obj.t_prev = obj.t_real;
            
            obj.tf = tf;
            obj.t_sim = t;
            
            % Variable updates - Time, percentage, display current time, 
            % display end time, average speed
            obj.t_real = obj.t_real + dt;
            
            hour_mask = 'HH:MM:SS';
            obj.t_curr_str = datestr(seconds(obj.t_real), hour_mask);
            
            % Percentage format
            perc_num = 100*t/tf;
            
            if(perc_num > 100)
                perc_num = 100;
            end
            
            % NOTE: Decompose the percentage into blocks of 
            % MOD_THRES sizes to improve readability
            MOD_THRES = 5;
            
            perc_trunc = perc_num - mod(perc_num, MOD_THRES);
            perc_str = num2str(perc_trunc);
            parts = strsplit(perc_str, '.');
            
            part1_perc = str2num(parts{1});
            if(length(parts) == 1)
                part2_perc = '00';
            else
                part2_perc = parts{2};
                part2_perc = terop(length(part2_perc)==2, part2_perc, [part2_perc, '0']);
            end
            
            perc = [part1_perc, '.', part2_perc];
            % ---------------
            
            SIG_NUMBERS = 3;
            
            if((perc_num < eps))
                obj.speed = 0;
            else
                obj.speed = perc_num/obj.t_real;
            end
            
            % Speed format
            speed_f = obj.speed;
            
            if(speed_f*10^SIG_NUMBERS > 1)
                speed_i = floor(speed_f);

                speed_dec_str = num2str(floor((speed_f - speed_i)*10^SIG_NUMBERS));
                speed_int_str = num2str(speed_i);

                if(str2num(speed_dec_str) == 0)
                    decimal_part = extend_str('0', SIG_NUMBERS);
                end
                
                while(length(speed_dec_str) ~= SIG_NUMBERS)
                    speed_dec_str = [speed_dec_str, '0'];
                end
                    
                speed_str = [speed_int_str, '.', speed_dec_str];
            
            else
                [speed_int, speed_dec] = dec2expnot(speed_f);
                speed_str = [num2str(speed_int), 'e', num2str(speed_dec)];
            end
            % ---------------
            
            % Final time
            if(perc < eps)
                t_f = 0;
                obj.t_end_str = datestr(seconds(t_f), 'HH:MM:SS');
                obj.t_left_str = datestr(seconds(t_f) - seconds(obj.t_real), 'HH:MM:SS');
            else
                t_f = floor((100/obj.speed)*100)/100;
                
                T_MAX = 99*3600 + 99*59 + 59;
                if(t_f > T_MAX)
                    obj.t_end_str = 'Undefined';
                else
                    obj.t_end_str = datestr(seconds(t_f), 'HH:MM:SS');
                end
                
                obj.t_left_str = datestr(seconds(t_f) - seconds(obj.t_real), 'HH:MM:SS');
            end
            
            % ---------------
            
            obj.msg = sprintf(obj.time_mask, part1_perc, part2_perc, ...
                              speed_str, obj.t_curr_str, ...
                              obj.t_left_str, obj.t_end_str);

            obj.t_real_vec = [obj.t_real_vec, obj.t_real];
            obj.speed_vec = [obj.speed_vec; obj.speed];
            obj.tf_real_vec = [obj.tf_real_vec, t_f];
            
            if(isvalid(obj.wb))
                waitbar(t/tf, obj.wb, obj.msg); 
            else
                warning('Invalid UI Figure. Continue instead.');
            end
        end
        
        function close_window(obj)
            h = obj.find_handle();
            
            if(~isempty(obj.tf_real_vec))
               % Erase waitbar
                t_f = obj.tf_real_vec(end);

                fprintf('Elapsed time is %.6f seconds.\n', t_f); 
            end
            
            delete(h);
        end
    end
end
