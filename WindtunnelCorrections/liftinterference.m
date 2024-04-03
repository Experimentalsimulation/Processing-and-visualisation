function BAL = liftinterference(BAL, tail_off_20, tail_off_40)
    % constants
    %b = 1.397; % [m]m wing span
    %votrexspanratio = 0.752688; % bv/b taken from figure 10.11 Barlow bv/b
    %bv = votrexspanratio * b; % downstream votrex span [m]
    %be = (b + bv)/2; % [m] equivalent span
    
    delta = 0.1; % Boundary correction factor off centernot taken into account
    tau2_tail = 0.736; 
    tau2 = 0.16; % same factor but at 0.75c 0.5 behind AC 
    S = 0.2172; % [m^2] Model reference area in this case wing area
    C = (1260 * 1800 - 2 * (300 * 300)) * 10^-6; % [m^2] windtunnel crossectional area

    %loop over all data to be corrected 
    for i = 1:numel(BAL.config)
        config = BAL.config{i};

        
        %all data required to do lift interference 
        V = BAL.windOn.(config).V; % not really used in calc only for lenght
        A = BAL.windOn.(config).AoA;
        CM = BAL.windOn.(config).CM25c_blocked;
        CD = BAL.windOn.(config).CD_blocked;

        dcmdat = BAL.windOn.(config).dcmdat;
        CLa = BAL.windOn.(config).CLa;

        BAL.windOn.(config).AoA_bc = zeros(1, numel(A));
        BAL.windOn.(config).CM_bc = zeros(1, numel(A));
        BAL.windOn.(config).CD_bc = zeros(1, numel(A));
 
        %Take correct tail off data based on V
        for j = 1:numel(V)
            alpha = A(j);
            
            if V(j) < 22
                % Find the matching row based on AoA and take CL
                CLwing = tail_off_20(tail_off_20.AoA >= alpha -0.1 & tail_off_20.AoA <= alpha + 0.1, :).CL;
                if isempty(CLwing)
                    warning('no mathing aoa found ')
                end

                if numel(CLwing) > 1
                    CLwing = CLwing(1)
                end

                
            else
                % Find the matching row based on AoA and take CL
                CLwing = tail_off_40(tail_off_40.AoA >= alpha -0.1 & tail_off_40.AoA <= alpha + 0.1, :).CL;
                if isempty(CLwing)
                    warning('no mathing aoa found ')
                end
                
                if numel(CLwing) > 1
                    CLwing = CLwing(1)
                end

            end
            % TODO check units of angles and derivatives rad or deg
            da = tau2 * delta * S/C * CLwing
            datail = delta * S/C * CLwing * (1 + tau2_tail);
            dcm025 = da * CLa(j)/8 + dcmdat(j) * datail;
            dCD = delta * S/C * CLwing^2
            if numel(da) > 1
                disp('help')
            end
            BAL.windOn.(config).AoA_bc(j) = A(j) + da;
            BAL.windOn.(config).CM_bc(j) = CM(j) + dcm025; 
            BAL.windOn.(config).CD_bc(j) = CD(j) + dCD
        end
    end
end
