function [OSPLs] = Get_OPS(MIC)

    p_ref = 0.00002;
    num_files = numel(MIC);
    
    for i = 1:num_files
        
        num_DP = numel(MIC{i}.PXX);
        
        for k = 1:num_DP
             
            f = MIC{i}.f{k};
            PPX = MIC{i}.PXX{k};

            aPPX = mean(PPX(:, 1:3), 2); % Calculate the mean along the rows (dimension 2)
            df = f(2) - f(1);

            p_overall = sum(aPPX.*df);
             
            OSPL = 20*log10(p_overall/p_ref);
            
            OSPLs{i}{k} = OSPL;
            
        end

        

    end
    


end