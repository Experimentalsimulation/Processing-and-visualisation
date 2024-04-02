function plotcontrolpowerV2(BAL)
% Define elevator deflection values
    elevatorDeflections = [0, 10, 20, 25, -10];
    
    % Define windspeeds and RPS settings
    windspeeds = [40];
    RPS_settings = unique(round(BAL.windOn.(BAL.config{6}).rpsM1));
    
    % Initialize plot data struct
    plotData = struct();
    slopes = struct()
    % Loop over windspeeds
    for w = 1:numel(windspeeds)
        % Loop over RPS settings
        for r = 1:numel(RPS_settings)
            % Create field name
            fieldName = sprintf('V%dRPS%d', windspeeds(w), RPS_settings(r));
            
            % Initialize CMPITCH values for the current combination
            CMPITCH_values = zeros(size(elevatorDeflections));
            
            % Extract CMPITCH for the current combination of windspeed and RPS
            for i = 6:numel(BAL.config)
                % Get the configuration name
                configName = BAL.config{i};
                
                % Extract CMPITCH, AoA, RPS, and windspeed for the current configuration
                CMPITCH = BAL.windOn.(configName).CMpitch;
                AoA = round(BAL.windOn.(configName).AoA);
                current_RPS = round(BAL.windOn.(configName).rpsM1);
                current_V = round(BAL.windOn.(configName).V);
                
                % Find indices where AoA is zero and windspeed and RPS match the current combination
                idx = find(AoA == 0 & current_RPS == RPS_settings(r) & current_V == windspeeds(w));
                
                % Store CMPITCH value corresponding to the matching elevator deflection
                CMPITCH_values(i-5) = mean(CMPITCH(idx));
            end
            
            % Store CMPITCH values in the plotData struct
            plotData.(fieldName) = CMPITCH_values;
        end
    end
    % Loop over windspeeds
    for w = 1:numel(windspeeds)
        % Loop over RPS settings
       
        % Create field name
        fieldName = sprintf('V%dPropOff', windspeeds(w));
        
        % Initialize CMPITCH values for the current combination
        CMPITCH_values = zeros(size(elevatorDeflections));
        
        % Extract CMPITCH for the current combination of windspeed and RPS
        for i = 1:5
            % Get the configuration name
            configName = BAL.config{i};
            
            % Extract CMPITCH, AoA, RPS, and windspeed for the current configuration
            CMPITCH = BAL.windOn.(configName).CMpitch;
            AoA = round(BAL.windOn.(configName).AoA);
            
            current_V = round(BAL.windOn.(configName).V);
            
            % Find indices where AoA is zero and windspeed and RPS match the current combination
            idx = find(AoA == 0 & current_V == windspeeds(w));
            
            % Store CMPITCH value corresponding to the matching elevator deflection
            CMPITCH_values(i) = CMPITCH(idx);
        end
        
        % Store CMPITCH values in the plotData struct
        plotData.(fieldName) = CMPITCH_values;
     
    end
    % Plot 
    % % Define elevator deflection values
    elevatorDeflections = [0, 10, 20, 25, -10];
    
    % Define colors and markers for plotting
    colors = {'b', 'r', 'g', 'b', 'r', 'g','m'};
    markers = { 'h', 'o', 's', 'd-', 'v-', 'o-', 's-'};
    
    % Initialize figure
    figure;
    hold on;
    
    % Loop over the fieldnames in plotData
    fnames = fieldnames(plotData);
    for i = 4:numel(fnames)
        % Get CMPITCH values for the current combination
        CMPITCH_values = plotData.(fnames{i});
        
        % Sort elevator deflections and CMPITCH values
        [elevatorDeflectionsSorted, sortIdx] = sort(elevatorDeflections);
        CMPITCH_valuesSorted = CMPITCH_values(sortIdx);
        
        % Plot CMPITCH versus elevator deflection with varying markers
        plot(elevatorDeflectionsSorted, CMPITCH_valuesSorted, markers{i}, 'Color', colors{i}, 'DisplayName', fnames{i});

        % Calculate slope (dCMPITCH/dde) using polyfit for linear regression
        validIndices = find(elevatorDeflectionsSorted >= -10 & elevatorDeflectionsSorted <= 10);
        p = polyfit(elevatorDeflectionsSorted(validIndices), CMPITCH_valuesSorted(validIndices), 1);
        slopes.(fnames{i}) = p(1); % Store the slope
    end

    
    % Add labels and legend
    xlabel('Elevator Deflection (degrees)');
    ylabel('CM');
    title('Control Power');
    legend('Location', 'best');
    grid on;
    
    % Hold off to end plotting
    hold off;
    % Print slopes
    fnames = fieldnames(slopes);
    for i = 1:numel(fnames)
        fprintf('Slope for Control Power %s: %f\n', fnames{i}, slopes.(fnames{i}));
    end
end
