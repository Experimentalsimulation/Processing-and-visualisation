function BAL = dcmdat(BAL)
    for i = 1:numel(BAL.config)
        config = BAL.config{i};
        V = BAL.windOn.(config).V;
        CM025c_tail = BAL.windOn.(config).CM25ch;
        AoA = BAL.windOn.(config).AoA;
        %split file in two v = 20 and V = 40 
        AoA_20 = [];
        CM025c_tail_20 =[];

        AoA_40 = [];
        CM025c_tail_40 =[];

        for j = 1:numel(V)
            if V(j) < 22
               AoA_20 =[AoA_20, AoA(j)];
               CM025c_tail_20 =[CM025c_tail_20, CM025c_tail(j)];

            else
                AoA_40 =[AoA_40, AoA(j)];
                CM025c_tail_40 =[CM025c_tail_40, CM025c_tail(j)];
            end
        end
        
        % Calculate the coefficients, least squares
        X_20 = [ones(length(AoA_20), 1), AoA_20']; % Design matrix
        model_20= (X_20' * X_20) \ (X_20' * CM025c_tail_20'); % Coefficients
        X_40 = [ones(length(AoA_40), 1), AoA_40']; % Design matrix
        model_40= (X_40' * X_40) \ (X_40' * CM025c_tail_40'); % Coefficients

        % slope (dcmdat)
        BAL.windOn.(config).dcmdat_20 = model_20(2);
        BAL.windOn.(config).dcmdat_40 = model_40(2); 
    end
end

