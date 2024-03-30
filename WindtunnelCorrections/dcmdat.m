function BAL = dcmdat(BAL)
    for i = 1:numel(BAL.config)
        config = BAL.config{i};
        V = BAL.windOn.(config).V;
        CM025c_tail = BAL.windOn.(config).CM25ch;
        AoA = BAL.windOn(config).AoA;
        %split file in two v = 20 and V = 40 
        AoA_20 = [];
        CM025c_tail_20 =[];

        AoA_40 = [];
        CM025c_tail_40 =[];

        for j = 1:numel(V)
            if V(j) < 22
               AoA_20 =[AoA20, AoA(j)];
               CM025c_tail_20 =[CM025c_tail_20, CM025c_tail(j)];

            else
                AoA_40 =[AoA40, AoA(j)];
                CM025c_tail_40 =[CM025c_tail_40, CM025c_tail(j)];
            end
        end
        model_20 = fitlm(AoA_20, CM025c_tail_20); % least squares regression between AOA an CMtail AoA of aircraft thus asuming zero downwash at tail (and 0 incidence offset however less important)
        model_40 = fitlm(AoA_40, CM025c_tail_40);
        BAL.windOn.(config).dcmat_20 = model_20.Coefficients.estimate(2);
        BAL.windOn.(config).dcmat_40 = model_40.Coefficients.estimate(2); 
    end
end

