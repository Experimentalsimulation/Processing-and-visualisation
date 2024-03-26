function [prms_corrected] = Get_prms_corrected(prms_on, prms_off, V_inf_experiment)


%Substract prop off p_rms to prop on P_rms

prms = prms_on - prms_off;



%Correct for scaling

V_inf_descent  = 149;  %Descent speed of Airvus a318 https://contentzone.eurocontrol.int/aircraftperformance/details.aspx?ICAO=A318

prms_corrected = prms * (V_inf_descent/V_inf_experiment)^2;

end