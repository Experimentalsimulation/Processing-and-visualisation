close all
clear
clc

%% Inputs
% path to folder containing the measurement data
fnFolder = './DATA'

% fn = {'propon_de0.txt','propon_demin10.txt','propon_de10.txt','propon_de20.txt','propon_de25.txt','propoff_de0.txt','propoff_demin10.txt','propoff_de10.txt','propoff_de20.txt','propoff_de25.txt'}; % structure of filenames to main txt file containing the averaged data - you can add multiple filenames here
fn = {'propoff_de0.txt','propon_de0.txt'}; % structure of filenames to main txt file containing the averaged data - you can add multiple filenames here
 
% settings for spectral analysis (pwelch function)
nB       = 25;      % number of bins - can be modified to change frequency resolution of spectra
nOverlap = 0;       % number of samples for overlap
fs       = 12800;   % sampling frequency [Hz]

% propeller geometry
D = 0.2032; % propeller diameter [m]

%% Load microphone calibration data
micCal = load('micCalData_AE4115labExercise');
micCal.F_mics(4:5,:) = 0;

%% Loop over all TDMS files of name "Measurement_i.tdms)" in the specified folder
for i=1:length(fn)
   
    % load data operating file
    AVGpath    = [fnFolder,'\',fn{i}];
    AVGdata{i} = load(AVGpath);
    
    opp{i}.DPN    = AVGdata{i}(:,1);
    opp{i}.vInf   = AVGdata{i}(:,7); % freestream velocity [m/s]
    opp{i}.AoA    = AVGdata{i}(:,13);  % angle of attack [deg]
    opp{i}.AoS    = AVGdata{i}(:,14);  % angle of sideslip [deg]
    opp{i}.RPS_M1 = AVGdata{i}(:,15);  % RPS motor 1 [Hz]
    opp{i}.RPS_M2 = AVGdata{i}(:,22);  % RPS motor 2 [Hz]
    opp{i}.J_M1   = opp{i}.vInf./(opp{i}.RPS_M1*D); % advance ratio motor 1
    opp{i}.J_M2   = opp{i}.vInf./(opp{i}.RPS_M2*D); % advance ratio motor 2
    
    % load microphone data
    for j=1:length(opp{i}.DPN) % loop over all the datapoints for this configuration
        
        % Construct filename (required in case of duplicate files)
        runNo = 1;
        TDMSpath = [fnFolder '/' fn{i}(1:end-4) '_run',num2str(opp{i}.DPN(j)),'_',sprintf('%03.0f',runNo),'.tdms'];
        % while exist(TDMSpath)==0 && runNo < 5
        %     runNo = runNo+1;
        %     TDMSpath = [TDMSpath(1:end-8),sprintf('%03.0f',runNo),'.tdms'];
        % end
        
        % load data
        rawData = ReadFile_TDMS(TDMSpath);
        disp(['Loaded file ' TDMSpath])
        
       % Apply calibration
        for k=1:6 % loop over the microphones     
            [MIC{i}.pMic{j}(k,:),~,~] = apply_cal_curve(fs,rawData{1}(:,k)-mean(rawData{1}(:,k)),micCal.f_oct,micCal.F_mics(k,:));
        end     
        MIC{i}.pMic{j}(7,:) = rawData{1}(:,7); % the inflow microphone data are stored with calibration factor applied
        
        % perform spectral analysis
        w        = hann(length(MIC{i}.pMic{j})/nB); % window
        wOvrlp   = length(w)*nOverlap; % overlap window
        [MIC{i}.PXX{j},MIC{i}.SPL{j},MIC{i}.f{j}] = spectralAnalysis(MIC{i}.pMic{j}.',w,wOvrlp,fs,[]);         
    end
    
end % end while loop over files

figure('Name','Spectra')
for i=1:7
    subplot(2,4,i), box on, hold on
    % plot(MIC{1}.f{6},MIC{1}.SPL{6}(:,i),'b')
    plot(MIC{2}.f{2},MIC{2}.SPL{2}(:,i)-MIC{1}.SPL{6}(:,i),'r')
    xlim([0 13])
    xlabel('Frequency f/RPS [-]')
    ylabel('SPL [dB]')
    title(['Mic ',num2str(i)])
    ylim([50 120])
end
   