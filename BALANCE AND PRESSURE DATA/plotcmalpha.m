function plotcmalpha(BAL)
    % Get the number of prop configurations
    numConfigs = {'propon_de0'};
    elevator_names = {'0', '10', 'min10'}
    % Initialize figure
    figure;
    DATA = struct();
    % Plot CM25c and CM25ch
    for i = 1:numel(numConfigs)
        uniqueAoA = unique(round(BAL.windOn.(numConfigs{i}).AoA));
        % Get the CM25c and alpha values for the current prop configuration
        CM25c = BAL.windOn.(numConfigs{i}).CMpitch25c;
        % AoA = BAL.windOn.(numConfigs{i}).AoA;
        V = BAL.windOn.(numConfigs{i}).V;
        uniqueRPS = unique(round(BAL.windOn.(numConfigs{i}).rpsM1));
        % filter uniqueRPS so that it only has values > 50
        uniqueRPS = uniqueRPS(uniqueRPS > 50);
        % Get the CM25ch values for the current prop configuration
        CM25ch = BAL.windOn.(numConfigs{i}).CM25ch;
        for j = 1:numel(uniqueRPS)
            RPS = uniqueRPS(j);
            CM25c_list = zeros(size(length(uniqueAoA)));
            CM25ch_list = zeros(size(length(uniqueAoA)));
            fieldname = sprintf('RPS%dElevatorAngle%d', RPS , i);
            for k = 1:numel(uniqueAoA)
                AoA = uniqueAoA(k);
                idx = find(round(BAL.windOn.(numConfigs{i}).AoA) == AoA & round(BAL.windOn.(numConfigs{i}).rpsM1) == RPS & round(BAL.windOn.(numConfigs{i}).V) == 40);
                CM25c_list(k) = mean(CM25c(idx));
                CM25ch_list(k) = mean(CM25ch(idx));
            end
            DATA.(fieldname).AoA = uniqueAoA;
            DATA.(fieldname).CM25c = CM25c_list;
            DATA.(fieldname).CM25ch = CM25ch_list;
        end
        % Plot CM25c vs alpha
        subplot(1, 2, 1);
        hold on;
        for j = 1:numel(uniqueRPS)
            RPS = uniqueRPS(j);
            fieldname = sprintf('RPS%dElevatorAngle%d', RPS , i);
            plot(DATA.(fieldname).AoA, DATA.(fieldname).CM25c, '-o', 'DisplayName', fieldname);
        end
        xlabel('Alpha');
        ylabel('CM25c');
        title('CM25c vs Alpha');
        legend;

        % Plot CM25ch vs alpha
        subplot(1, 2, 2);
        hold on;
        for j = 1:numel(uniqueRPS)
            RPS = uniqueRPS(j);
            fieldname = sprintf('RPS%dElevatorAngle%d', RPS , i);
            plot(DATA.(fieldname).AoA, DATA.(fieldname).CM25ch, '-o', 'DisplayName', fieldname);
        end
        xlabel('Alpha');
        ylabel('CM25ch');
        title('CM25ch vs Alpha');
        legend;
    end
end
