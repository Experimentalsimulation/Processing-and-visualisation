function [OASPL] = Get_OASPL(prms_corrected)


        p_ref = 0.00002;

        OASPL = 20*log10(prms_corrected/p_ref);



end