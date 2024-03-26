function [prms] = Get_prms(MIC)
    

             
        f = MIC.f;
        PPX = MIC.PXX;
        aPPx = [];

        for  i = 1:length(f)

              aPPx = [aPPx, mean(PPX(i, 1:3))]; % Calculate the mean along the rows (dimension 2) 1:3 means only mic 1 to 3 are used

        end

        df = f(2) - f(1);

        prms= sum(aPPx.*df);
             

end