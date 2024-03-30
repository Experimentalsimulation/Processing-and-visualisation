function [BAL, Trimmed_conditions] = find_trimmed_conditions(BAL)
    %% This function finds the trimmed conditions for 3 configurations
    % These 3 configs are:
    % V = 40 --- RPS = 51
    % V = 40 --- RPS = 59
    % V = 40 --- RPS = 67

    % Define elevator deflection values
    elevatorDeflections = [0, 10, 20, 25, -10];
    
    % Define windspeeds and RPS settings
    windspeeds = [40];
    RPS_settings = unique(round(BAL.windOn.(BAL.config{7}).rpsM1));
    
    % Initialize plot data struct
    Trimmed_conditions = struct();
    trim_data = struct()
    % Loop over windspeeds
    for w = 1:numel(windspeeds)
        % Loop over RPS settings
        for r = 1:numel(RPS_settings)
            % Create field name
            fieldName = sprintf('V%dRPS%d', windspeeds(w), RPS_settings(r));
            
            % Initialize CMpitch values for the current combination
            CMpitch_values = zeros(size(elevatorDeflections));
            CL_values = zeros(size(elevatorDeflections));
            CD_values = zeros(size(elevatorDeflections));
            % Extract CMpitch for the current combination of windspeed and RPS
            for i = 6:numel(BAL.config)
                % Get the configuration name
                configName = BAL.config{i};
                
                % Extract CMpitch, AoA, RPS, and windspeed for the current configuration
                CMpitch = BAL.windOn.(configName).CMpitch;
                CL = BAL.windOn.(configName).CL;
                CD = BAL.windOn.(configName).CD;
                AoA = round(BAL.windOn.(configName).AoA);
                current_RPS = round(BAL.windOn.(configName).rpsM1);
                current_V = round(BAL.windOn.(configName).V);
                
                % Find indices where AoA is zero, and windspeed and RPS match the current combination
                idx = find(AoA == 0 & current_RPS == RPS_settings(r) & current_V == windspeeds(w));
                disp(configName)
                disp(idx)
                % Store CMpitch values corresponding to the matching elevator deflections
                CMpitch_values(i-5) = CMpitch(idx);
                CL_values(i-5) = CL(idx);
                CD_values(i-5) = CD(idx);
            end
            % Sort elevator deflections and CLh values
            [elevatorDeflections_sorted, sortIdx] = sort(elevatorDeflections);
            CMpitch_values_sorted = CMpitch_values(sortIdx);
            CL_values_sorted = CL_values(sortIdx);
            CD_values_sorted = CD_values(sortIdx);
            % Store data
            trim_data.(fieldName).CM = CMpitch_values_sorted;
            trim_data.(fieldName).CL = CL_values_sorted;
            trim_data.(fieldName).CD = CD_values_sorted;
            trim_data.(fieldName).de = elevatorDeflections_sorted
            
            % Plot CM vs elevator deflection
            figure
            plot(elevatorDeflections_sorted, CMpitch_values_sorted, 'o-')
            xlabel('Elevator deflection [deg]')
            ylabel('CM_{pitch}')
            title(fieldName)
            grid on
            % Plot CL vs elevator deflection
            figure
            plot(elevatorDeflections_sorted, CL_values_sorted, 'o-')
            xlabel('Elevator deflection [deg]')
            ylabel('CL')
            title(fieldName)
            grid on
            % Plot CD vs elevator deflection
            figure
            plot(elevatorDeflections_sorted, CD_values_sorted, 'o-')
            xlabel('Elevator deflection [deg]')
            ylabel('CD')
            title(fieldName)
            grid on
        end

        % Calculate trimmed conditions by interpolating quadratically CM, CL, CD over elevator deflection and finding elevator deflection for CM = 0
        % Loop over RPS settings
        for r = 1:numel(RPS_settings)
            % Create field name
            fieldName = sprintf('V%dRPS%d', windspeeds(w), RPS_settings(r));
            
            % Interpolate CM, CL, CD over elevator deflection
            CM = trim_data.(fieldName).CM;
            CL = trim_data.(fieldName).CL;
            CD = trim_data.(fieldName).CD;
            de = trim_data.(fieldName).de;
            % Interpolate CM, CL, CD over elevator deflection
            p_CM = polyfit(de, CM, 1);
            p_CL = polyfit(de, CL, 1);
            p_CD = polyfit(de, CD, 2);
            
            % Find elevator deflection for CM = 0
            de_trim = roots(p_CM);
            de_trim = de_trim(imag(de_trim) == 0);

            % Store trimmed conditions
            Trimmed_conditions.(fieldName).de_trim = de_trim;
            Trimmed_conditions.(fieldName).CL_trim = polyval(p_CL, de_trim);
            Trimmed_conditions.(fieldName).CD_trim = polyval(p_CD, de_trim);
            Trimmed_conditions.(fieldName).CM_trim = 0;

        end
    end
    
end