%==========================================================================
% Contact: Woutijn J. Baars, w.j.baars@tudelft.nl
%
% Input:   e.g. time-series of acoustic pressure data
%             - units: [Pa] (or Volts, or ...)
%
% Generate 1D spectrum.
%
%==========================================================================


%% SCRIPT------------------------------------------------------------------
clear all; clc; close all;


%% SIGNAL------------------------------------------------------------------

load JetNoiseData;   % example dataset of a linear microphone array,
                     % next to a jet flow
dataA = Data(:,10);  % one microphone out of the array (total 56 mics)
dataB = Data(:,40);  % another microphone out of the array (total 56 mics)
clear Data;
fs = SampleRate;     % sampling frequency, [Hz]

% plot time-series of the two microphone signals
figure;
Naq = length(dataA);    % # of acquisition samples
dt = 1/fs;              % sample time, [s]
subplot(1,2,1);
plot(0:dt:dt*(Naq-1),dataA); hold on;
legend('mic A'); axis([0 65 -20 20]);
xlabel('t (s)'); ylabel('p(t) (Pa)');
subplot(1,2,2);
plot(0:dt:dt*(Naq-1),dataB); hold on;
legend('mic B'); axis([0 65 -30 30]);
xlabel('t (s)'); ylabel('p(t) (Pa)');


%% SPECTRAL ANALYSIS-RAW---------------------------------------------------

N = 2^14;           % ensemble size for Fourier analysis, [-]
                    % sets lowest frequency to resolve, and dictates # of averages
                    %
                    % THIS 'N' you can adjust, e.g., N = 2^11, or N = 2^16
                    % When this number is larger: better spectral
                    % resolution, but less 'ensemble averaging'...so
                    % spectrum is noisier.
                    %
B = floor(Naq/N);   % # of enemble averages per data file (Nfile samples), [-]
df = fs/N;          % frequency resolution, [Hz]
flab = (0:N-1)*df;  % frequency discretization, [Hz]
T = dt*N;           % recording time one partition, [s]
windowing = true;   % hannding window or not? (not much different for broadband signal)
dB_ref = 20e-6;     % 20 micro-Pa reference pressure, [Pa]

% function for spectrum:
[~,flab,~,df,phiA,N] = fcn_spectrumN_V1(N,1/fs,dataA,2); % [bst = 1: spatial-data, bst = 2: time-data]
[~,flab,~,df,phiB,N] = fcn_spectrumN_V1(N,1/fs,dataB,2); % [bst = 1: spatial-data, bst = 2: time-data]

% Parseval's theorem: check scaling-----------------------------------
% signal's energy - integrating the spectrum:
p2int = trapz(phiA(1:N/2,1))*df; % Trapezoidal-integration: Int[PSD function(f)]df, [unit^2 = energy], slightly less accurate: p2int = sum(Guu(1:N/2,1))*df;
% signal's energy - same as variance? ratio = 1?
display(strcat(['Ratio = ',num2str(p2int/(std(dataA)).^2)])); % CHECK?
% --------------------------------------------------------------------

% spectrum in Pa^2/Hz (with linear scales...so that area under the curve is
% proportional to the variance)
figure(100);
h1 = plot(flab(1:N),phiA(1:N)); hold on;
h2 = plot(flab(1:N),phiB(1:N)); hold on;
legend('mic A','mic B'); axis([0 1000 0 0.50]);
xlabel('f (Hz)'); ylabel('\phi(f) (Pa^2/Hz)');
title('Acoustic spectrum in Pa^2/Hz, with linear-axis');

% OASPL [dB] – SINGLE NUMBER FOR A TIME SERIES
ApOASPL_dB = 20*log10(std(dataA)/dB_ref);
BpOASPL_dB = 20*log10(std(dataB)/dB_ref);

% SPSL: [dB/Hz] - SPECTRUM IN DB/Hz
SPSLA = 20*log10(sqrt(phiA/dB_ref^2));
SPSLB = 20*log10(sqrt(phiB/dB_ref^2));

% spectrum in dB/Hz (so basically log-log)
figure(200);
h1 = semilogx(flab(1:N/2),SPSLA(1:N/2)); hold on;
h1 = semilogx(flab(1:N/2),SPSLB(1:N/2)); hold on;
% % filtered version with 5% bandwidth-moving filter
% h2 = loglog(flab(1:N/2),fcn_BMF(Guu(1:N/2)',5),'Color','b','LineWidth',2.0); hold on;
legend('mic A','mic B'); axis([1 100000 -10 100]);
xlabel('f (Hz)'); ylabel('SPSL (dB/Hz)');
title('Acoustic spectrum in dB/Hz, with log-axis');


%% END