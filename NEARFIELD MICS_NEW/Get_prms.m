function [prms] = Get_prms(MIC)
    

        
        prms = [];
        for i = 1:length(MIC.pMic(:,1))

               prms(i) = std(MIC.pMic(i,:));

        end


end