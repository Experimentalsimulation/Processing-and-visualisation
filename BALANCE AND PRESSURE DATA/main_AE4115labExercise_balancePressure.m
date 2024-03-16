%% Main processing file LTT data AE4115 lab exercise 2021-2022
% T Sinnige
% 28 March 2022

%% Initialization
% clear workspace, figures, command window
clear 
close all
clc

%% Inputs

% define root path on disk where data is stored
diskPath = './DATA';

% get indices balance and pressure data files
[idxB,idxP] = SUP_getIdx;

% filename(s) of the raw balance files - DEFINE AS STRUCTURE WITH AS MANY FILENAMES AS DESIRED 
% The name of the file must start with "raw_". If the filename starts with
% a character that is not a letter, a plus sign, or a minus sign, the code
% will throw an error in BAL_process.m and you will have to add some code 
% there to handle the exception. (the filenames are used as fields in a 
% structure and these must start with a letter, so you will need to replace
% the first character with a letter. For the + and - signs this has already
% been implemented.
% fn_BAL = {'BAL/raw_propoff_de0.txt','BAL/raw_propoff_de10.txt','BAL/raw_propoff_de20.txt','BAL/raw_propoff_de25.txt','BAL/raw_propoff_demin10.txt', 'BAL/raw_propon_de0.txt', 'BAL/raw_propon_de10.txt','BAL/raw_propon_de20.txt','BAL/raw_propn_de25.txt','BAL/raw_propon_demin10.txt' };
fn_BAL = {'BAL/raw_propoff_de0.txt','BAL/raw_propoff_de10.txt','BAL/raw_propoff_de20.txt','BAL/raw_propoff_de25.txt','BAL/raw_propoff_demin10.txt', 'BAL/raw_propon_de0.txt', 'BAL/raw_propon_de10.txt','BAL/raw_propon_de20.txt','BAL/raw_propon_de25.txt','BAL/raw_propon_demin10.txt'};

% filename(s) of the zero-measurement (tare) data files. Define an entry
% per raw data files. In case multiple zero-measurements are available for
% a datapoint, then add a structure with the filenames of the zero 
% measurements at the index of that datapoint.
% fn0 = {'BAL/raw_propoff_zero.txt','BAL/raw_propoff_zero.txt','BAL/raw_propoff_zero.txt','BAL/raw_propoff_zero.txt','BAL/raw_propoff_zero.txt','BAL/raw_propon_zero.txt','BAL/raw_propon_zero.txt','BAL/raw_propon_zero.txt','BAL/raw_propon_zero.txt','BAL/raw_propon_zero.txt'}; 
fn0 = {'BAL/raw_propoff_zero.txt','BAL/raw_propoff_zero.txt','BAL/raw_propoff_zero.txt','BAL/raw_propoff_zero.txt','BAL/raw_propoff_zero.txt','BAL/raw_propon_zero.txt','BAL/raw_propon_zero.txt','BAL/raw_propon_zero.txt','BAL/raw_propon_zero.txt','BAL/raw_propon_zero.txt'}; 



% filenames of the pressure data files (same comments apply as for balance 
% data files)
fn_PRS = {'PRESSURE/raw_propoff_de0.txt','PRESSURE/raw_propoff_de10.txt','PRESSURE/raw_propoff_de20.txt','PRESSURE/raw_propoff_de25.txt','PRESSURE/raw_propoff_demin10.txt','PRESSURE/raw_propon_de0.txt','PRESSURE/raw_propon_de10.txt','PRESSURE/raw_propon_de20.txt','PRESSURE/raw_propon_de25.txt','PRESSURE/raw_propon_demin10.txt'};


% wing geometry
b     = 1.4*cosd(4); % span [m]
cR    = 0.222; % root chord [m]
cT    = 0.089; % tip chord [m]
S     = b/2*(cT+cR);   % reference area [m^2]
taper = cT/cR; % taper ratio
c     = 2*cR/3*(1+taper+taper^2)/(1+taper); % mean aerodynamic chord [m]

% prop geometry
D        = 0.2032; % propeller diameter [m]
R        = D/2;   % propeller radius [m]

% moment reference points
XmRefB    = [0,0,0.0465/c]; % moment reference points (x,y,z coordinates) in balance reference system [1/c] 
XmRefM    = [0.25,0,0];     % moment reference points (x,y,z coordinates) in model reference system [1/c] 

% incidence angle settings
dAoA      = 0.0; % angle of attack offset (subtracted from measured values)   
dAoS      = 0.0; % angle of sideslip offset (subtracted from measured values)
modelType = 'aircraft'; % options: aircraft, 3dwing, halfwing
modelPos  = 'inverted'; % options: normal, inverted
testSec   = 5;    % test-section number   

%% Run the processing code to get balance and pressure data
PRS = PRS_process(diskPath,fn_PRS,idxP);
BAL = BAL_process(diskPath,fn_BAL,fn0,idxB,D,S,b,c,XmRefB,XmRefM,dAoA,dAoS,modelType,modelPos,testSec,PRS);

%% Write your code here to apply the corrections and visualize the data

% Substract model off balance data

modelOffData = readModelOffData('.\DATA\modeloffdata.txt');
%disp(modelOffData);
correctedBAL = correctBALData(BAL, modelOffData) 
BAL = correctedBAL

% Get Tc coefficient for prop on data 

BAL = calculateDeltaCT(BAL,D,S)


% Result Plotting
plotTCvsRPS(BAL)
% % Create figures for CL vs CD, CL vs AoA, and CM vs AoA
% figure;
% 
% % Set a speed tolerance (adjust as needed)
% speed_tolerance = 2; % in m/s
% desired_AoA_sequence = [-5, 0, 5, 10];
% % Loop through each configuration
% for i = 1:numel(BAL.config)
%     % Extract relevant data
%     AoA = BAL.windOn.(BAL.config{i}).AoA;
%     CL = BAL.windOn.(BAL.config{i}).CL;
%     CD = BAL.windOn.(BAL.config{i}).CD;
%     CM = BAL.windOn.(BAL.config{i}).CMpitch;
%     V = BAL.windOn.(BAL.config{i}).V;
%     AoA = round(AoA)
%     % Round speeds to the nearest integer
%     rounded_speeds = round(V);
% 
%     % Group speeds based on tolerance
%     unique_speeds = unique(rounded_speeds);
% 
%     % Loop through each unique speed
%     for j = 1:length(unique_speeds)
%         % Extract data for the current speed
%         idx_speed = find(rounded_speeds == unique_speeds(j));
% 
%         % Check if the sequence has exactly 4 data points
%         if sum(ismember(desired_AoA_sequence, AoA(idx_speed))) == 4
%             % Order the data for the current speed according to the desired sequence
%             [~, order_idx] = ismember(desired_AoA_sequence, AoA(idx_speed));
% 
%             % Plot CL vs CD for the current speed
%             subplot(1, 3, 1);
%             plot(CL(idx_speed(order_idx)), CD(idx_speed(order_idx)), 'o-', 'DisplayName', [BAL.config{i}, ', V = ', num2str(unique_speeds(j)), ' m/s']);
%             hold on;
% 
%             % Plot CL vs AoA for the current speed
%             subplot(1, 3, 2);
%             plot(AoA(idx_speed(order_idx)), CL(idx_speed(order_idx)), 'o-', 'DisplayName', [BAL.config{i}, ', V = ', num2str(unique_speeds(j)), ' m/s']);
%             hold on;
% 
%             % Plot CM vs AoA for the current speed
%             subplot(1, 3, 3);
%             plot(AoA(idx_speed(order_idx)), CM(idx_speed(order_idx)), 'o-', 'DisplayName', [BAL.config{i}, ', V = ', num2str(unique_speeds(j)), ' m/s']);
%             hold on;
%         end
%     end
% end
% 
% % Add labels and legends for CL vs CD
% subplot(1, 3, 1);
% xlabel('CL');
% ylabel('CD');
% title('CL vs CD for Sequences with 4 Data Points (Ordered by Desired AoA Sequence)');
% legend('Location', 'Best');
% grid on;
% 
% % Add labels and legends for CL vs AoA
% subplot(1, 3, 2);
% xlabel('Angle of Attack (degrees)');
% ylabel('CL');
% title('CL vs AoA for Sequences with 4 Data Points (Ordered by Desired AoA Sequence)');
% legend('Location', 'Best');
% grid on;
% 
% % Add labels and legends for CM vs AoA
% subplot(1, 3, 3);
% xlabel('Angle of Attack (degrees)');
% ylabel('CM');
% title('CM vs AoA for Sequences with 4 Data Points (Ordered by Desired AoA Sequence)');
% legend('Location', 'Best');
% grid on;




% figure
% plot(BAL.windOn.propon_de0.AoA, BAL.windOn.propon_de0.CL, '-*b'); % Plot the first dataset with blue lines and markers
% hold on; % Keep the plot and add subsequent plots to it
% plot(BAL.windOn.propon_de10.AoA, BAL.windOn.propon_de10.CL, '-*r'); % Plot the second dataset with red lines and markers
% plot(BAL.windOn.propon_de20.AoA, BAL.windOn.propon_de20.CL, '-*g'); % Plot the third dataset with green lines and markers
% hold off; % Release the plot for new figures
% 
% % Optionally, add labels and a legend
% xlabel('Angle of Attack (AoA)');
% ylabel('Coefficient of Lift (CL)');
% legend('de=0', 'de=10', 'de=20', 'Location', 'Best');
% title('RAW Lift Coefficient vs. Angle of Attack for Different Elevator Deflections');



