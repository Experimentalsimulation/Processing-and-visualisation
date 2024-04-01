function BAL = liftinterference(BAL, tail_off_20, tail_off_40)
    % constants
    %b = 1.397; % [m]m wing span
    %votrexspanratio = 0.752688; % bv/b taken from figure 10.11 Barlow bv/b
    %bv = votrexspanratio * b; % downstream votrex span [m]
    %be = (b + bv)/2; % [m] equivalent span
    
    delta = 0.122; % Boundary correction factor off centernot taken into account
    tau2_tail = 1.13; % Windtunnel shape factor acounts for tail lenght and average between 0 vertical offset and 0.1 be offset 
    tau2 = 0.11; % same factor but at 0.5c 0.25 behind AC 
    S = 0.2172; % [m^2] Model reference area in this case wing area
    C = (1260 * 1800 - 2 * (300 * 300)) * 10^-6; % [m^2] windtunnel crossectional area

    %loop over all data to be corrected 
    for i = 1:numel(BAL.config)
        config = BAL.config{i};

        
        %all data required to do lift interference 
        V = BAL.windOn.(config).V;
        A = BAL.windOn.(config).AoA;
        CM = BAL.windOn.(config).CMpitch25c;

        dcmdat = BAL.windOn.(config).dcmdat;
        CLa = BAL.windOn.(config).CLa;

        BAL.windOn.(config).AoA_bc = zeros(1, numel(A));
        BAL.windOn.(config).CM25c_bc = zeros(1, numel(A));

        %Take correct tail off data based on V
        for j = 1:numel(V)
            alpha = A(j);
            
            if V(j) < 22
                % Find the matching row based on AoA and take CL
                if alpha > 0
                    CLwing = tail_off_20(tail_off_20.AoA >= alpha * 0.94 & tail_off_20.AoA <= alpha * 1.06, :).CL;
                else
                    CLwing = tail_off_20(tail_off_20.AoA <= alpha * 0.94 & tail_off_20.AoA >= alpha * 1.06, :).CL;
                end

                if isempty(CLwing)
                    warning('no mathing aoa found ')
                end

                
            else
                % Find the matching row based on AoA and take CL
                if alpha > 0
                    CLwing = tail_off_40(tail_off_40.AoA >= alpha * 0.94 & tail_off_40.AoA <= alpha * 1.06, :).CL;
                else
                    CLwing = tail_off_40(tail_off_40.AoA <= alpha * 0.94 & tail_off_40.AoA >= alpha * 1.06, :).CL;
                end

                if isempty(CLwing)
                    warning('no mathing aoa found ')
                end
            end
            % TODO check units of angles and derivatives rad or deg
            da = tau2 * delta * S/C * CLwing
            datail = delta * S/C * CLwing * (1 + tau2_tail);
            dcm025 = da * CLa(j)/8 + dcmdat(j) * datail;
            if numel(da) > 1
                disp('help')
            end
            BAL.windOn.(config).AoA_bc(j) = A(j) + da;
            BAL.windOn.(config).CM25c_bc(j) = CM(j) + dcm025; 
        end
    end
end
