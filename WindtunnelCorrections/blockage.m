function [] = blockage(BAL)
 % Iterate over configurations in BAL
    for i = 1:numel(BAL.config)
        
        config = BAL.config{i};
        
        % Extract CT values from BAL
        CT = BAL.windOn.(config).CT; %  This should be called Tc
        V = BAL.windOn.(config).V;
        q = BAL.windOn.(config).q;
        CL = BAL.windOn.(config).CL;
        CD = BAL.windOn.(config).CD;
        CM = BAL.windOn.(config).CMpitch25c;

        %Maskells method 
        if config(1:6) == 'propon'
            propon = true;
            if strlength(config) > 11
                elevator = -10; % naming of config minus ten makes longest name
            else
                elevator = str2num(config(10:end)); % convert substring after _de to numericvalue
            end
        else
            propon = false;
            if strlength(config) > 12
                elevator = -10; % naming of config minus ten makes longest name
            else
                elevator = str2num(config(11:end)); % convert substring after _de to numericvalue
            end
        end
        
        %file = determine_filename(elevator, propon, true); % last boolean is windOn which ofcourse is the only option
        [cl2_20, cd_20] = get_cl2_cd(BAL, v_interest, rps_interest, propon, de)
        [cl2_20, cd_20] = get_Cl2_and_Cd(file,20);
        [cl2_40, cd_40] = get_Cl2_and_Cd(file,40);
        if isempty(cl2_20)
            abc_20 = NaN
        else
            abc_20 = get_abc_plot_Cl2_vs_Cd(cl2_20, cd_20);
        end

        if isempty(cl2_40)
            abc_40 = NaN;
        else
            abc_40 = get_abc_plot_Cl2_vs_Cd(cl2_40, cd_40);
        end

        eps_wake = zeros(1,length(V));
       
        for j = 1:length(V)
            v = V(j);
            cl = CL(j);
            cd = CD(j);
            
            if v < 25 & ~isnan(abc_20)
                a = abc_20(1);
                b = abc_20(2);
                c = abc_20(3);
                eps_wake(j) = wakeblockage(a,b,c,cl,cd);

            end
            if v > 35 & ~isnan(abc_40)
                a = abc_40(1);
                b = abc_40(2);
                c = abc_40(3);
                eps_wake(j) = wakeblockage(a,b,c,cl,cd);
            end
            
        end

        eps_solid = solidblockage(V) * ones(1,length(V));
        eps_reg = reshape(Regenblockage(CT), 1, []);
        epsilon = eps_solid + eps_wake + eps_reg;
        disp('blockagefunction line 59')
        disp(epsilon)
        disp(eps_wake)
        disp(eps_reg)
        disp(eps_solid)
     
        
        BAL.windOn.(BAL.config{i}).V_blocked = V .* (1 + epsilon);
        BAL.windOn.(BAL.config{i}).q_blocked = q .* (1 + epsilon).^2;

        BAL.windOn.(BAL.config{i}).CL_blocked = CL .* (1 + epsilon).^-2;
        BAL.windOn.(BAL.config{i}).CD_blocked = CD .* (1 + epsilon).^-2;
        BAL.windOn.(BAL.config{i}).CMpitch25c_blocked = CM .* (1 + epsilon).^-2;
        BAL.windOn.(BAL.config{i}).CT_blockd = CT .* (1 + epsilon).^-2;

    end 
end