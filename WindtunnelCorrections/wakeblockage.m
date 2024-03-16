function [epsilon] = wakeblockage(CDu, CDi, CD0)
%WAKEBLOCKAGE computes wake blockage epsilon
% Inputs: angle of attack [rad]
%         velocity [m/s]
% 
S = 1; % Not Implimented
C = 1; % Not Implimented

epsilon = S/(4*C)*CD0 + 5 * S/(4 * C) * (CDu - CDi - CD0)

end

