close all
clear
clc

load('MIC_track_propon.mat')
load('MIC_track_propoff.mat')


%Plot the spectral densiy of the corrected propon

figure;
hold on;

plot(MIC_track_propon(1).MIC.f, MIC_track_propon(1).MIC.SPL_corrected(:,1));
plot(MIC_track_propon(1).MIC.f, MIC_track_propon(1).MIC.SPL_corrected(:,7));


% Grid lines
grid on;

% Axis titles
title('SPL')
xlabel('f [Hz]');
ylabel('SPL [dB]');
legend('RPS = 33.4','RPS = 25.6')

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


%Add prop off oaspls to the plot
for i=1:length(MIC_track_propoff)
    if MIC_track_propoff(i).V_inf == 40 && MIC_track_propoff(i).alpha == 0
        for j = 1:length(des)
            if MIC_track_propoff(i).de == des(j)

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
legend('-10^\circ','0^\circ','10^\circ','20^\circ','25^\circ', 'Location', 'NorthWest');




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
legend('-5^\circ','0^\circ','5^\circ','10^\circ', 'Location', 'NorthWest');


%OASPL vs RPS at varying V, de = 0, v = 40 m/s, aoa = 0 for mic 1
Vs = [20,40];


data = {};
for i = 1:length(Vs)
    data(i).RPS = [];
    data(i).OASPL = [];
end


for i=1:length(MIC_track_propon)
    if MIC_track_propon(i).alpha == 0 && MIC_track_propon(i).de == 0
        for j = 1:length(Vs)
            if MIC_track_propon(i).V_inf == Vs(j)

                RPS = MIC_track_propon(i).J;
                OASPL = MIC_track_propon(i).OASPL(1);

                data(j).RPS = [data(j).RPS,RPS];
                data(j).OASPL = [data(j).OASPL,OASPL];

            end
        end
    end
end

figure;
hold on;
for i = 1:length(Vs)
    plot(data(i).RPS, data(i).OASPL);
end

% Grid lines
grid on;

% Axis titles
title('OASPL vs RPS at varying V, de = 0, v = 40 m/s, aoa = 0 for mic 1');
xlabel('RPS [rev/s]');
ylabel('OASPL [dB]');

% Legend
legend('20 m/s', '40 m/s', 'Location', 'NorthWest');
