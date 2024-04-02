close all;
clear all;
clc;

load('MIC_track_propon.mat')
load('MIC_track_propoff.mat')



%Plot OSPL difference between mic 1,2,3 and 6, scratched, make table
%instead



%Plot the spectral densiy of the corrected propon

figure;
hold on;

datapoint1 = 26;
datapoint2 = 34;


plot(MIC_track_propon(26).MIC.f, MIC_track_propon(26).MIC.PXX_corrected(:,1));
plot(MIC_track_propon(26).MIC.f, MIC_track_propon(26).MIC.SPL_corrected(:,1));



plot(MIC_track_propon(28).MIC.f, MIC_track_propon(28).MIC.PXX_corrected(:,1));
plot(MIC_track_propon(28).MIC.f, MIC_track_propon(28).MIC.SPL_corrected(:,1));


% plot(MIC_track_propon(datapoint2).MIC.f, MIC_track_propon(datapoint2).MIC.SPL_corrected(:,1));
% plot(MIC_track_propon(datapoint2).MIC.f, MIC_track_propon(datapoint2).MIC.SPL_corrected(:,7));


% Grid lines
grid on;

% Axis titles
title('Spectral density of two de settings at V_inf = 40m/s, RPS = 66.9 deg, alpha = 0 deg, for mic 1')
xlabel('f [Hz]');
ylabel('SPL [dB]');
legend('\alpha = 0^\circ PXX corrected','\alpha = 0^\circ SPL corrected', '\alpha = 10^\circ PXX corrected','\alpha = 10^\circ SPL corrected')





%OASPL vs RPS at varying de, aoa = 0, v = 40 m/s for mic 1
des = [-10,0,10,20,25];


data = {};
data_off = {};

for i = 1:length(des)   %Initiate field contents for prop-on
    data(i).RPS = [];
    data(i).OASPL = [];
end

for i = 1:length(des)   %Initiate field contents for prop-on
    data_off(i).RPS = [];
    data_off(i).OASPL = [];
end


for i=1:length(MIC_track_propon)
    if MIC_track_propon(i).V_inf == 40 && MIC_track_propon(i).alpha == 0
        for j = 1:length(des)
            if MIC_track_propon(i).de == des(j)

                RPS = MIC_track_propon(i).RPS;
                OASPL = MIC_track_propon(i).OASPL(1);

                data(j).RPS = [data(j).RPS,RPS];
                data(j).OASPL = [data(j).OASPL,OASPL];

            end
        end
    end
end


% %Add prop off oaspls to the plot
% for i=1:length(MIC_track_propoff)
%     if MIC_track_propoff(i).V_inf == 40 && MIC_track_propoff(i).alpha == 0
%         for j = 1:length(des)
%             if MIC_track_propoff(i).de == des(j)
% 
%                 RPS = 0;
%                 OASPL = MIC_track_propoff(i).OASPL(1);
% 
%                 data_off(j).RPS = [data_off(j).RPS,RPS];
%                 data_off(j).OASPL = [data_off(j).OASPL,OASPL];
% 
%             end
%         end
%     end
% end

figure;
hold on;
for i = 1:length(des)
    plot(data(i).RPS, data(i).OASPL);
end


% % Add the horizontal line
% line([min(50), max(70)], [data_off(1).OASPL, data_off(1).OASPL], 'Color', 'r', 'LineStyle', '--');

% Grid lines
grid on;

% Axis titles
title('OASPL vs RPS at varying de, aoa = 0, v = 40 m/s for mic 1')
xlabel('RPS [rev/s]');
ylabel('OASPL [dB]');

% Legend
legend('\delta_e = -10^\circ','\delta_e = 0^\circ','\delta_e = 10^\circ','\delta_e = 20^\circ','\delta_e = 25^\circ', 'Location', 'NorthWest');




%OASPL vs RPS at varying aoa, de = 0, v = 40 m/s for mic 1
aoas = [-5,0,5,10];


data = {};
for i = 1:length(aoas)
    data(i).RPS = [];
    data(i).OASPL = [];
end


for i=1:length(MIC_track_propon)
    if MIC_track_propon(i).V_inf == 40 && MIC_track_propon(i).de == 0
        for j = 1:length(aoas)
            if MIC_track_propon(i).alpha == aoas(j)

                RPS = MIC_track_propon(i).RPS;
                OASPL = MIC_track_propon(i).OASPL(1);

                data(j).RPS = [data(j).RPS,RPS];
                data(j).OASPL = [data(j).OASPL,OASPL];

            end
        end
    end
end


%Add prop off oaspls to the plot
for i=1:length(MIC_track_propoff)
    if MIC_track_propoff(i).V_inf == 40 && MIC_track_propoff(i).de == 0
        for j = 1:length(aoas)
            if MIC_track_propoff(i).alpha == aoas(j)

                RPS = 0;
                OASPL = MIC_track_propoff(i).OASPL(1);

                data_off(j).RPS = [data_off(j).RPS,RPS];
                data_off(j).OASPL = [data_off(j).OASPL,OASPL];

            end
        end
    end
end

figure;
hold on;
for i = 1:length(aoas)
    plot(data(i).RPS, data(i).OASPL);
end


% Grid lines
grid on;

% Axis titles
title('OASPL vs RPS at varying aoa, de = 0, v = 40 m/s for mic 1');
xlabel('RPS [rev/s]');
ylabel('OASPL [dB]');

% Legend
legend('\alpha = -5^\circ','\alpha = 0^\circ','\alpha = 5^\circ','\alpha = 10^\circ', 'Location', 'NorthWest');


% %OASPL vs RPS at varying V, de = 0, v = 40 m/s, aoa = 0 for mic 1
% Vs = [20,40];
% 
% 
% data = {};
% for i = 1:length(Vs)
%     data(i).RPS = [];
%     data(i).OASPL = [];
% end
% 
% 
% for i=1:length(MIC_track_propon)
%     if MIC_track_propon(i).alpha == 0 && MIC_track_propon(i).de == 0
%         for j = 1:length(Vs)
%             if MIC_track_propon(i).V_inf == Vs(j)
% 
%                 RPS = MIC_track_propon(i).J;
%                 OASPL = MIC_track_propon(i).OASPL(1);
% 
%                 data(j).RPS = [data(j).RPS,RPS];
%                 data(j).OASPL = [data(j).OASPL,OASPL];
% 
%             end
%         end
%     end
% end
% 
% figure;
% hold on;
% for i = 1:length(Vs)
%     plot(data(i).RPS, data(i).OASPL);
% end
% 
% % Grid lines
% grid on;
% 
% % Axis titles
% title('OASPL vs RPS at varying V, de = 0, v = 40 m/s, aoa = 0 for mic 1');
% xlabel('RPS [rev/s]');
% ylabel('OASPL [dB]');
% 
% % Legend
% legend('20 m/s', '40 m/s', 'Location', 'NorthWest');

%OASPL vs RPS at alpha = 0, de = 0, v = 40 m/s for mic 1 in raw, corrected,
%and scaled formats


data = {};
data.RPS = [];
data.OASPL_raw = [];
data.OASPL_corrected = [];
data.OASPL_scaled = [];


for i=1:length(MIC_track_propon)
    if MIC_track_propon(i).V_inf == 40 && MIC_track_propon(i).de == 0 && MIC_track_propon(i).alpha == 0



            RPS = MIC_track_propon(i).RPS;

            OASPL_raw = MIC_track_propon(i).OASPL_raw(1);
            OASPL_corrected = MIC_track_propon(i).OASPL_unscaled(1);
            OASPL_scaled = MIC_track_propon(i).OASPL(1);

            data.RPS = [data.RPS,RPS];

            data.OASPL_raw = [data.OASPL_raw,OASPL_raw];
            data.OASPL_corrected = [data.OASPL_corrected,OASPL_corrected];
            data.OASPL_scaled = [data.OASPL_scaled,OASPL_scaled];


    end
end

for i=1:length(MIC_track_propoff)
    if MIC_track_propoff(i).V_inf == 40 && MIC_track_propoff(i).de == 0 && MIC_track_propoff(i).alpha == 0

            OASPL_off = MIC_track_propoff(i).OASPL(1);
            data.OASPL_off = OASPL_off;


    end
end


figure;
hold on;
line([data.RPS(1), data.RPS(end)], [data.OASPL_off, data.OASPL_off], 'Color', 'r', 'LineStyle', '--');
plot(data.RPS, data.OASPL_raw);
plot(data.RPS, data.OASPL_corrected);
plot(data.RPS, data.OASPL_scaled);



% Grid lines
grid on;

% Axis titles
title('OASPL vs RPS at alpha = 0, de = 0, v = 40 m/s for mic 1, in at different levels of correction');
xlabel('RPS [rev/s]');
ylabel('OASPL [dB]');

% Legend
legend('prop off raw OASPL','prop on raw OASPL','Corrected OASPL','Corrected and scaled OASPL', 'Location', 'NorthWest');