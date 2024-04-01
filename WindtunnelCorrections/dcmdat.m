function BAL = dcmdat(BAL)
    for i = 1:numel(BAL.config)
        config = BAL.config{i};
        V = BAL.windOn.(config).V;
        CM025c_tail = BAL.windOn.(config).CM25ch;
        CL = BAL.windOn.(config).CL;
        AoA = BAL.windOn.(config).AoA;

        %split file in two v = 20 and V = 40 
        AoA_20 = [];
        CM025c_tail_20 =[];
        CL_20 = [];

        AoA_40 = [];
        CM025c_tail_40 =[];
        CL_40 = [];

        dcmdat_20 = zeros(1,numel(V));
        dcmdat_40 = zeros(1,numel(V));

        for j = 1:numel(V)
            if V(j) < 22
               AoA_20 =[AoA_20, AoA(j)];
               CM025c_tail_20 =[CM025c_tail_20, CM025c_tail(j)];
               CL_20  = [CL_20,CL(j)];
               dcmdat_20(1,j) = 1;

            else
                AoA_40 =[AoA_40, AoA(j)];
                CM025c_tail_40 =[CM025c_tail_40, CM025c_tail(j)];
                CL_40  = [CL_40,CL(j)];
                dcmdat_40(j) = 1;
            end
        end
        % just copying the arrays filled with 0 and 1 based on V 
        CLalpha_20 = dcmdat_20;
        CLalpha_40 = dcmdat_40;

        
        % Calculate the coefficients, least squares
        X_20 = [ones(length(AoA_20), 1), AoA_20'];   
        X_40 = [ones(length(AoA_40), 1), AoA_40'];

        % Calculate the condition number of the matrix X' * X
        c_20 = cond(X_20' * X_20);
        c_40 = cond(X_40' * X_40);
        
        % Check if the condition number is above a threshold
        threshold = 1e2;
        if c_20 > threshold | numel(AoA_20) < 2
            disp(['For ', config, ' at V = 20 no dcmdat can be found thus no lift interference correction on the moment coefficient is applied']);
            model_20 = [0;0];
            CLa20 = [0;0];
        else
            model_20 = (X_20' * X_20) \ (X_20' * CM025c_tail_20'); % Coefficients least squares
            CLa20 = (X_20' * X_20) \ (X_20' * CL_20'); % Coefficients least squares
        end

        if c_40 > threshold | numel(AoA_40) < 2
            disp(['For ', config, ' at V = 40 no dcmdat can be found thus no lift interference correction on the moment coefficient is applied']);
            model_40 = [0;0];
            CLa40 = [0;0];
        else
            model_40 = (X_40' * X_40) \ (X_40' * CM025c_tail_40'); % Coefficients least squares
            CLa40 = (X_40' * X_40) \ (X_40' * CL_40'); % Coefficients least squares
        end


        
        % slope (dcmdat)
        dcmdat_20 = dcmdat_20 .* model_20(2,1);
        dcmdat_40 = dcmdat_40 .* model_40(2,1);
        CLalpha_20 = CLalpha_20 .* CLa20(2,1);
        CLalpha_40 = CLalpha_40 .* CLa40(2,1);

        dcmdat = dcmdat_20 + dcmdat_40;
        CLa = CLalpha_40 + CLalpha_20; 
        BAL.windOn.(config).dcmdat = dcmdat;
        BAL.windOn.(config).CLa = CLa;
         
    end
end

