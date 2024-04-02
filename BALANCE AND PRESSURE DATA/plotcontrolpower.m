function plotData = plotcontrolpower(BAL)
    % Define elevator deflection values
    elevatorDeflections = [0, 10, 20, 25, -10];
    
    % Define windspeeds and RPS settings
    windspeeds = [20, 40];
    RPS_settings = unique(round(BAL.windOn.(BAL.config{6}).rpsM1));
    
    % Initialize plot data struct
    plotData = struct();
    
    % Loop over windspeeds
    for w = 1:numel(windspeeds)
        % Loop over RPS settings
        for r = 1:numel(RPS_settings)
            % Create field name
            fieldName = sprintf('V%dRPS%d', windspeeds(w), RPS_settings(r));
            
            % Initialize CMpitch values for the current combination
            CMpitch_values = zeros(size(elevatorDeflections));
            
            % Extract CMpitch for the current combination of windspeed and RPS
            for i = 6:numel(BAL.config)
                % Get the configuration name
                configName = BAL.config{i};
                
                % Extract CMpitch, AoA, RPS, and windspeed for the current configuration
                CMpitch = BAL.windOn.(configName).CMpitch;
                AoA = round(BAL.windOn.(configName).AoA);
                current_RPS = round(BAL.windOn.(configName).rpsM1);
                current_V = round(BAL.windOn.(configName).V);
                
                % Find indices where AoA is zero, and windspeed and RPS match the current combination
                idx = find(AoA == 0 & current_RPS == RPS_settings(r) & current_V == windspeeds(w));
                
                % Store CMpitch values corresponding to the matching elevator deflections
                CMpitch_values(i-5) = mean(CMpitch(idx));
            end
            
            % Store CMpitch values in the plotData struct
            plotData.(fieldName) = CMpitch_values;
        end
    end
    
    % Plot 
    % Define colors for plotting
    colors = {'b', 'r', 'g', 'm', 'c', 'k','b', 'r', 'g', 'm', 'c', 'k'};
    
    % Initialize figure
    figure;
    hold on;
    
    % Loop over the fieldnames in plotData
    fnames = fieldnames(plotData);
    for i = 10:numel(fnames)
        % Get CMpitch values for the current combination
        CMpitch_values = plotData.(fnames{i});
        
        % Sort elevator deflections and CLh values
        [elevatorDeflectionsSorted, sortIdx] = sort(elevatorDeflections);
        CMpitch_valuesSorted = CMpitch_values(sortIdx);

        % Plot CMpitch versus elevator deflection
        plot(elevatorDeflectionsSorted, CMpitch_valuesSorted, 'o-', 'Color', colors{i}, 'DisplayName', fnames{i});
    end

    % Add labels and legend
    xlabel('Elevator Deflection (degrees)');
    ylabel('CM');
    title('Control Power');
    legend('Location', 'best');
    grid on;
    
    % Hold off to end plotting
    hold off;
end
