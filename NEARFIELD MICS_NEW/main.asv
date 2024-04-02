close all
clear
clc

%% Inputs
% path to folder containing the measurement data
fnFolder = './DATA'


fn = {'propon_de0.txt','propon_demin10.txt','propon_de10.txt','propon_de20.txt','propon_de25.txt','propoff_de0.txt','propoff_demin10.txt','propoff_de10.txt','propoff_de20.txt','propoff_de25.txt'}; % structure of filenames to main txt file containing the averaged data - you can add multiple filenames here
% fn = {'propoff_de0.txt','propon_de0.txt'}; % structure of filenames to main txt file containing the averaged data - you can add multiple filenames here



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
    opp{i}.vInf   = AVGdata{i}(:,7);   % freestream velocity [m/s]
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





%Load and sort the MIC data

[MIC_track_propon, MIC_track_propoff] = Get_MIC_track(MIC,fn,opp);

%Load and sort the BAL data


[BAL_track_propon, BAL_track_propoff] = Get_BAL_track();





%For every prop on measurement, assigns the relevant prop off measurement
%for correction
correction_index_track = [];
for i = 1:length(MIC_track_propon)
    for j = 1: length(MIC_track_propoff)
        if MIC_track_propon(i).de == MIC_track_propoff(j).de && MIC_track_propon(i).V_inf == MIC_track_propoff(j).V_inf && MIC_track_propon(i).alpha == MIC_track_propoff(j).alpha
            correction_index_track(i) = j;
            break
        end
    end

end


%Apply correctoni to propon measurements
for i = 1:length(MIC_track_propon)





    %Prms and OASPL
    prms_on = Get_prms(MIC_track_propon(i).MIC);
    prms_off = Get_prms(MIC_track_propoff(correction_index_track(i)).MIC);

    prms_corrected = Get_prms_corrected(prms_on, prms_off, MIC_track_propon(i).V_inf,1); %1 if scaling required, 0 otherwise

    OASPL = Get_OASPL(prms_corrected);



  

    MIC_track_propoff(correction_index_track(i)).prms = prms_off;

    MIC_track_propon(i).prms = prms_on;
    MIC_track_propon(i).prms_corrected = prms_corrected;
    MIC_track_propon(i).OASPL = OASPL;


    %Get a raw OASPL for correction comparison

    MIC_track_propon(i).OASPL_raw = Get_OASPL(prms_on);
    prms_corrected = Get_prms_corrected(prms_on, prms_off, MIC_track_propon(i).V_inf,0); %1 if scaling required, 0 otherwise
    MIC_track_propon(i).OASPL_unscaled = Get_OASPL(prms_corrected);

    %Correct spectral density

    
    PXX_on = MIC_track_propon(i).MIC.PXX;
    PXX_off = MIC_track_propoff(correction_index_track(i)).MIC.PXX;


    MIC_track_propon(i).MIC.PXX_corrected = Get_prms_corrected(PXX_on, PXX_off, MIC_track_propon(i).V_inf,1);

    %Add option to handle negative PXX values

    for a = 1:length(MIC_track_propon(i).MIC.PXX_corrected(1,:))
        for b = 1:1:length(MIC_track_propon(i).MIC.PXX_corrected(:,1))
            if MIC_track_propon(i).MIC.PXX_corrected(b,a) < 0.00002^2
               MIC_track_propon(i).MIC.PXX_corrected(b,a) = 0.00002^2;
            end
        end
    end
 
    MIC_track_propon(i).MIC.SPL_corrected = 10*log10(MIC_track_propon(i).MIC.PXX_corrected./0.00002^2);
    
    PXX_off_corrected = PXX_off.* (149/MIC_track_propon(i).V_inf)^2;

    MIC_track_propoff(correction_index_track(i)).MIC.SPL_corrected =  10*log10(PXX_off_corrected./0.00002^2);


end

for i = 1:length(MIC_track_propoff)

    prms_off = Get_prms(MIC_track_propoff(i).MIC);

    OASPL = Get_OASPL(prms_off);

    MIC_track_propoff(i).prms = prms_off;
    MIC_track_propoff(i).prms_corrected = prms_off;
    MIC_track_propoff(i).OASPL = OASPL;

end

save('MIC_track_propon.mat','MIC_track_propon' )

save('MIC_track_propoff.mat','MIC_track_propoff')


% figure('Name','Spectra')
% for i=1:7
%     subplot(2,4,i), box on, hold on
%     plot(MIC_track_propon(1).MIC.f,MIC_track_propon(1).MIC.SPL(:,i),'b')
%     plot(MIC_track_propoff(1).MIC.f,MIC_track_propoff(1).MIC.SPL(:,i),'r')
%     xlabel('Frequency f/RPS [-]')
%     ylabel('SPL [dB]')
%     title(['Mic ',num2str(i)])
%     legend('Prop-on','prop-off')
% end
% 
% 
% figure('Name','OASPL')
% 
% plot(MIC_track_propon(1).OASPL,'b')
% xlabel('mic [-]')
% ylabel('OASPL [dB]')
% title(['Mic ',num2str(i)])
   