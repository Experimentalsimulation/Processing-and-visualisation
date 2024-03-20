function [da, dcm025] = liftinterference(CLwing, CL_alpha, dcmdat)
%LIFTINTERFERENCE Summary of this function goes here
%   Detailed explanation goes here
% constants
b = 1.397; % [m]m wing span
votrexspanratio = 0.752688 % bv/b taken from figure 10.11 Barlow bv/b
bv = votrexspanratio * b; % downstream votrex span [m]
delta = 0.122; % Boundary correction factor off centernot taken into account
tau2_tail = 1.13; % Windtunnel shape factor acounts for tail lenght and average between 0 vertical offset and 0.1 be offset 
tau2 = 0.11; % same factor but at 0.5c 0.25 behind AC 

be = (b + bv)/2; % [m] equivalent span
S = 0.2172; % [m^2] Model reference area in this case wing area
C = (1260 * 1800 - 2 * (300 * 300)) * 10^-6; % [m^2] windtunnel crossectional area

da = tau2 * delta * S/C * CLwing
datail = delta * S/C * CLwing * (1 + tau2_tail)

dcm025 = da * CL_alpha/8 + dcmat * datail




end

