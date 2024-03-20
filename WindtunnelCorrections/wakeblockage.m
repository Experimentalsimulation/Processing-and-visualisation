function [epsilon] = wakeblockage(a, b, c, CLu, CDu)
%WAKEBLOCKAGE computes wake blockage epsilon
% Inputs: angle of attack [rad]
%         velocity [m/s]
% 

CD0 = a;
CDi = CLu^2 * b;

S = 0.2172; % [m^2] Model reference area in this case wing area

%Tunnel crossection 
C = (1260 * 1800 - 2 * (300 * 300)) * 10^-6; % [m^2] windtunnel crossectional area

epsilon = S/(4 * C) * CD0 + 5 * S/(4 * C) * (CDu - CDi - CD0)

end

