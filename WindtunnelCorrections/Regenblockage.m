function [epsilon] = Regenblockage(rps, V, T)
%REGENBLOCKAGE calculate epsilon for blockage by regen eq. 2.14
% With inputs calculate Tc with Tc calculate blockage due to propellors 
% (Tc should be negative!)

Tc = -0.02 % Not Implimented
Sp = 1 % Not Impliented
C = 1 % Not Implimnted

epsilon = Tc/sqrt(1+2*Tc) * Sp/C
end

