function BAL = blockage(BAL)

 % Iterate over configurations in BAL
    for i = 1:numel(BAL.config)
        
        config = BAL.config{i};
        
        % Extract CT values from BAL
        V = BAL.windOn.(config).V;
        q = BAL.windOn.(config).q;
        CL = BAL.windOn.(config).CL;
        CD = BAL.windOn.(config).CD;
        CM = BAL.windOn.(config).CMpitch;
        CM_25 = BAL.windOn.(config).CMpitch25c;
       


        %initialising epsilon wake array 
        eps_wake = zeros(1,length(V));


        % Maskells method 
        if config(1:6) == 'propon'
            TC = BAL.windOn.(config).TC; 
            % propon = true;
            if strlength(config) > 11
                elevator = -10; % naming of config minus ten makes longest name
            else
                elevator = str2double(config(10:end)); % convert substring after _de to numericvalue
            end
        else
            TC = zeros(1,numel(V));
            % propon = false;
            if strlength(config) > 12
                elevator = -10; % naming of config minus ten makes longest name
            else
                elevator = str2double(config(11:end)); % convert substring after _de to numericvalue
            end
        end

       
        
        rps = 0; % take wake from prop off as propellor effect is taken to be seperate
        propon = false;

        for j = 1:length(V)

            %file = determine_filename(elevator, propon, true); % last boolean is windOn which ofcourse is the only option\
            % BAl , V , rps, propon, de
            
            if V(j) <= 22 
                
                    [cl2_20, cd_20] = get_cl2_cd(BAL, 20, rps, propon, elevator);
                    
                    if isempty(cl2_20)
                        disp(['no abc ', config, V(j), rps])
                        disp([cl2_40, cd_40])
                        abc_20 = NaN;
                    else
                        abc_20 = get_abc_plot_Cl2_vs_Cd(cl2_20, cd_20);
                    end
            
                    %eps_wake = zeros(1, length(V(V<22))) % Lenght of V array where v == 20 
                    %eps_wake = zeros(1,length(V));
                    %eps_wake = zeros(1,4); % now all wake blockage epsilon arrays should all be sized 4
                   
                    
                    cl = CL(j,1);
                    cd = CD(j,1);
                        
                    if  ~isnan(abc_20)
                        a = abc_20(1);
                        b = abc_20(2);
                        c = abc_20(3);
                        eps_wake(j) = wakeblockage(a,b,c,cl,cd);
                    end   
                

    
           else % V = 40
                    %for rps = [51.4, 59.1 66.9] % rps settings 40 m/s
                       
                       [cl2_40, cd_40] = get_cl2_cd(BAL, 40, rps, propon, elevator);
    
                       if isempty(cl2_40)
                            abc_40 = NaN;
                            disp(['no abc', config, V(j), rps])
                            disp([cl2_40, cd_40])
                       else
                            abc_40 = get_abc_plot_Cl2_vs_Cd(cl2_40, cd_40);
                       end

                       cl = CL(j,1);
                       cd = CD(j,1);
    
                       if  ~isnan(abc_40)
                            a = abc_40(1);
                            b = abc_40(2);
                            c = abc_40(3);
                            eps_wake(j) = wakeblockage(a,b,c,cl,cd);
                       end 
             end    %end %for rps in [] v =40
        end % if V = 20 / else v = 40 
        

        eps_solid = solidblockage() * ones(1,length(V));
        eps_reg = reshape(Regenblockage(TC), 1, []);
        if numel(eps_wake) ~= numel(eps_reg)
            disp('help')
        end
        if numel(eps_solid) ~= numel(eps_reg)
            disp('help2')
        end
        epsilon = eps_solid + eps_wake + eps_reg;
        BAL.windOn.(BAL.config{i}).V_blocked = reshape(V,1,[]) .* (1 + epsilon);
        BAL.windOn.(BAL.config{i}).q_blocked = reshape(q,1,[]) .* (1 + epsilon).^2;
        BAL.windOn.(BAL.config{i}).CL_blocked = reshape(CL,1,[]) .* (1 + epsilon).^-2;
        BAL.windOn.(BAL.config{i}).CD_blocked = reshape(CD,1,[]) .* (1 + epsilon).^-2;
        BAL.windOn.(BAL.config{i}).CM_blocked = reshape(CM,1,[]) .* (1 + epsilon).^-2;
        BAL.windOn.(BAL.config{i}).CM25c_blocked = reshape(CM_25,1,[]) .* (1 + epsilon).^-2;
        if config(1:6) == 'propon'
            BAL.windOn.(BAL.config{i}).TC_blocked = reshape(TC,1,[]) .* (1 + epsilon).^-2;
        end
     end 
            
            


end