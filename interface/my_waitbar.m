classdef my_waitbar
    properties
        idx = tic;
        
        % Mask for message ovre progress bar
        time_mask = '%3d.%s %% - %s [%%/s] [%s - %s]';
        
        % mwssage on title
        name = '';
        msg = '';
        
        % Simulation time
        t_sim = 0;
        t_real = 0;
        
        % Real time
        t_curr_str = '';
        t_end_str = '';
        
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
            obj.name = name;
            
            if(nargin == 1)
                msg = 'teste1 \n teste2';
            end
            
            obj.t_curr_str = datestr(seconds(0), 'HH:MM:SS');
            obj.t_end_str = datestr(seconds(0), 'HH:MM:SS');
            
            obj.msg = sprintf(obj.time_mask, 0, obj.speed, ...
                              obj.t_curr_str, obj.t_end_str);
            
            cancel_callback = 'setappdata(gcbf,''canceling'',1)';
            obj.wb = waitbar(0, obj.msg,  'Name', obj.name, ... 
                             'CreateCancelBtn', cancel_callback);
            
            wb_texts = findall(obj.wb, 'type', 'text');
            set(wb_texts, 'Interpreter', 'none');
            
%             hChildren = get(obj.wb, 'Children');
%             for k = 1:length(hChildren)
%                 hChild = hChildren(k);
%                 if isfield(get(hChild), 'Style')  && ...
%                    strcmpi(get(hChild,'Style'),'pushbutton')
%                    
%                    hChildPos = get(hChild,'Position');                   
%                    staticTextPos = hChildPos;
%                    
%                    staticTextPos(1) = 10;
%                    staticTextPos(2) = staticTextPos(2) - 20;
%                    
%                    hPauseBtn = uicontrol(obj.wb, ...
%                                          'Style', 'text', ...
%                                          'String', msg,...
%                                          'Position', staticTextPos);    
%                 end
%             end
            
            obj.previous_t = tic;
        end
        
        function pauseButtonCallback(hSource, eventdata)
            pauseWaitbar = ~pauseWaitbar;
        end
        
        function cancelButtonCallback(hSource, eventdata)
            cancelWaitbar = 1;
        end
        
        function h = find_handle(obj)
            hs = findall(0,'type','figure','tag','TMWWaitbar');
            
            handles = [];
            for i = 1:length(hs)
                % XXX: Improve unique id
                unique_id = hs(i).Children(2).Title.String;

                if(strcmp(unique_id, obj.msg))
                    h = hs(i);
                    handles = [handles; hs(i)];
                end
            end
            
            if(length(handles) ~= 1)
                warning('There is more than a handle with prescripted ID.');
            end
            h = handles;
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
                
        function obj = update_waitbar(obj, t, tf)
            dt = toc(uint64(obj.previous_t));
            obj.previous_t = tic;
            obj.t_prev = obj.t_real;

            obj.tf = tf;
            obj.t_sim = t;
            
            % Variable updates - Time, percentage, display current time, 
            % display end time, average speed
            obj.t_real = obj.t_real + dt;
            
            time_mask = 'HH:MM:SS';            
            obj.t_curr_str = datestr(seconds(obj.t_real), time_mask);
            
            % Speed format
            speed = obj.speed;
            integer_part = floor(speed);
            
            SIG_NUMBERS = 1;
            dec_n = (speed - integer_part)*10^SIG_NUMBERS;
            
            decimal_part = num2str(floor(dec_n));
            integer_part = num2str(integer_part);

            if(str2num(decimal_part) == 0)
                decimal_part = extend_str('0', SIG_NUMBERS);
            end
            
            speed_new = [integer_part, '.', decimal_part];
            % ---------------
            
            % Percentage format
            perc = 100*t/tf;
            
            if(perc > 100)
                perc = 100;
            end

            if((perc < eps))
                t_f = 0;
                obj.speed = 0;
            else
                obj.speed = perc/obj.t_real;
                t_f = floor((100/obj.speed)*100)/100;
            end

            MOD_THRES = 5;
            perc = perc - mod(perc, MOD_THRES);
            perc = num2str(perc);            
            parts = strsplit(perc, '.');
            
            part1_perc = str2num(parts{1});
            if(length(parts) == 1)
                part2_perc = '00';
            else
                part2_perc = parts{2};
                part2_perc = terop(length(part2)==2, part2, [part2, '0']);
            end
            
            perc = [part1_perc, '.', part2_perc];
            % ---------------

            obj.t_end_str = datestr(seconds(t_f), 'HH:MM:SS');
            obj.msg = sprintf(obj.time_mask, part1_perc, part2_perc, ...
                              speed_new, obj.t_curr_str, obj.t_end_str);

            obj.t_real_vec = [obj.t_real_vec, obj.t_real];
            obj.speed_vec = [obj.speed_vec; obj.speed];
            obj.tf_real_vec = [obj.tf_real_vec, t_f];
            
            if(isvalid(obj.wb))
               waitbar(t/tf, obj.wb, obj.msg); 
            else
                warning('Invalid UI Figure. Continue instead.');
            end
            
            EPS = 1e-2;
            if(t/tf > 1 - EPS)
                obj.close_window();
            end
        end
        
        function close_window(obj)
            h = obj.find_handle();
            
            if(~isempty(obj.tf_real_vec))
               % Erase waitbar
                tf = obj.tf_real_vec(end);

                fprintf('Elapsed time is %.6f seconds.\n', tf); 
            end
            
            delete(h);
        end
    end
end