function plotTCvsRPS(BAL)
    % Initialize figure
    figure;

    % Extract data for the current configuration
    configName = 'propon_de10';
    TC = BAL.windOn.(configName).TC2;
    RPS = BAL.windOn.(configName).rpsM1;
    V = BAL.windOn.(configName).V;
    uniqueAoA = unique(round(BAL.windOn.(configName).AoA));
    TC_AoA = struct();

    % Store data in new struct
    for i = 1:numel(uniqueAoA)
        fieldname = sprintf('AoA_%d', i);
        idx = find(round(BAL.windOn.(configName).AoA) == uniqueAoA(i) & round(V) == 40);
        TC_AoA.(fieldname).TC = TC(idx);
        TC_AoA.(fieldname).RPS = RPS(idx);
        TC_AoA.(fieldname).V = V(idx);
        TC_AoA.(fieldname).AoA = uniqueAoA(i);
    end

    % Plot TC vs RPS for each fieldname
    hold on;
    colors = {'r', 'g', 'b', 'm', 'c', 'y'};
    markers = {'x-', 'o-', '+-', '*-', 's-', 'd-'};
    legendLabels = {};
    for i = 1:numel(uniqueAoA)
        fieldname = sprintf('AoA_%d', i);
        TC = TC_AoA.(fieldname).TC;
        RPS = TC_AoA.(fieldname).RPS;
        color = colors{mod(i-1, numel(colors))+1};
        marker = markers{mod(i-1, numel(markers))+1};
        plot(RPS, TC, [color marker], 'DisplayName', sprintf('AoA = %d', uniqueAoA(i)));
        legendLabels = [legendLabels, sprintf('AoA = %d', uniqueAoA(i))]; % Concatenate legend labels
    end
    hold off;
    xlabel('RPS');
    ylabel('TC');
    title('TC vs RPS');
    legend(legendLabels, 'Location', 'Best');
end

