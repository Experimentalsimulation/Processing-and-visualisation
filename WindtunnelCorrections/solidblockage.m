function [epsilon] = solidblockage()
%SOLIDBLOCKAGE compute total epsilon for solid blockage of all parts
% Input V [m/s] and output epsilon 

% coefficients of all the parts in order
% fuselage, nacelles, wingstruts, aft strut, Wing, HT, VT 
K = [0.908, 0.9302, 1.133, 1.125, 1.0475, 1.02, 1.035];

% volumes of all the parts in same order
V = [0.0160632, 0.0015842, 0.0035296, 0.0004491, 0.0030229, 0.0009751, 0.0003546]; % [m^3]

%Tunnel shape factor 
tau = 0.888;

%Tunnel crossection 
C = (1260 * 1800 - 2 * (300 * 300)) * 10^-6;
epsilon =  sum((K * tau .* V)/C^(3/2)); 
end

