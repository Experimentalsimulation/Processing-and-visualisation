function [OASPL] = Get_OASPL(prms_corrected)

        OASPL = [];
        p_ref = 0.00002;

        for i = 1:length(prms_corrected)
                OASPL(i) = real(10*log10(prms_corrected(i)/(p_ref^2)));
                if OASPL(i) == -Inf
                    OASPL(i) = 0;
                end


        end



end