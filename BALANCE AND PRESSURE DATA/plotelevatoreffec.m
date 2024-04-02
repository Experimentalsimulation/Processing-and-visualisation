function plotData = plotelevatoreffec(BAL)
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
            
            % Initialize CL values for the current combination
            CL_values = zeros(size(elevatorDeflections));
            
            % Extract CL for the current combination of windspeed and RPS
            for i = 6:numel(BAL.config)
                % Get the configuration name
                configName = BAL.config{i};
                
                % Extract CL, AoA, RPS, and windspeed for the current configuration
                CL = BAL.windOn.(configName).CL;
                AoA = round(BAL.windOn.(configName).AoA);
                current_RPS = round(BAL.windOn.(configName).rpsM1);
                current_V = round(BAL.windOn.(configName).V);
                
                % Find indices where AoA is zero and windspeed and RPS match the current combination
                idx = find(AoA == 0 & current_RPS == RPS_settings(r) & current_V == windspeeds(w));
                
                % Store CL value corresponding to the matching elevator deflection
                CL_values(i-5) = mean(CL(idx));
            end
            
            % Store CL values in the plotData struct
            plotData.(fieldName) = CL_values;
        end
    end
    % Loop over windspeeds
    for w = 1:numel(windspeeds)
        % Loop over RPS settings
       
        % Create field name
        fieldName = sprintf('V%dPropOff', windspeeds(w));
        
        % Initialize CL values for the current combination
        CL_values = zeros(size(elevatorDeflections));
        
        % Extract CL for the current combination of windspeed and RPS
        for i = 1:5
            % Get the configuration name
            configName = BAL.config{i};
            
            % Extract CL, AoA, RPS, and windspeed for the current configuration
            CL = BAL.windOn.(configName).CL;
            AoA = round(BAL.windOn.(configName).AoA);
            
            current_V = round(BAL.windOn.(configName).V);
            
            % Find indices where AoA is zero and windspeed and RPS match the current combination
            idx = find(AoA == 0 & current_V == windspeeds(w));
            
            % Store CL value corresponding to the matching elevator deflection
            CL_values(i) = CL(idx);
        end
        
        % Store CL values in the plotData struct
        plotData.(fieldName) = CL_values;
     
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
        % Get CL values for the current combination
        CL_values = plotData.(fnames{i});
        
        % Sort elevator deflections and CL values
        [elevatorDeflectionsSorted, sortIdx] = sort(elevatorDeflections);
        CL_valuesSorted = CL_values(sortIdx);
        
        % Plot CL versus elevator deflection with varying markers
        plot(elevatorDeflectionsSorted, CL_valuesSorted, markers{i}, 'Color', colors{i}, 'DisplayName', fnames{i});

        % Calculate slope (dCL/dde) using polyfit for linear regression
        idx = find(elevatorDeflectionsSorted >= -10 & elevatorDeflectionsSorted <= 10);
        p = polyfit(elevatorDeflectionsSorted(idx), CL_valuesSorted(idx), 1);
        slopes.(fnames{i}) = p(1); % Store the slope
    end

    
    % Add labels and legend
    xlabel('Elevator Deflection (degrees)');
    ylabel('CL');
    title('Elevator Effectiveness');
    legend('Location', 'best');
    grid on;
    
    % Hold off to end plotting
    hold off;
    % Print slopes
    fnames = fieldnames(slopes);
    for i = 1:numel(fnames)
        fprintf('Slope for Elevator Effectiveness %s: %f\n', fnames{i}, slopes.(fnames{i}));
    end
end


  