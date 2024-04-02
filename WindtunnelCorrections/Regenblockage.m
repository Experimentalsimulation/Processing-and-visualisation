function [epsilon] = Regenblockage(Tc)
%REGENBLOCKAGE calculate epsilon for blockage by regen eq. 2.14
% With inputs calculate Tc with Tc calculate blockage due to propellors 
% (Tc should be negative!)

Sp = pi/4 * 0.2032^2; % [m^2] propellor disk area

%Tunnel crossection 
C = (1260 * 1800 - 2 * (300 * 300)) * 10^-6; % [m^2] windtunnel crossectional area

epsilon = -1 * Tc./sqrt(1+2.*Tc) * Sp/C;
end

