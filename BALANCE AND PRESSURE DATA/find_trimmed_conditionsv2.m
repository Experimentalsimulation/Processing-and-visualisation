function [BAL, Trimmed_conditions] = find_trimmed_conditionsv2(BAL)
    %% This function finds the trimmed conditions for all angles of attack for 3 configurations
    % Define elevator deflection values
    elevatorDeflections = [0, 10, 20, 25, -10];
    
    % Define windspeed
    windspeeds = [40];
    
    % Extract RPS settings from the BAL structure
    RPS_settings = unique(round(BAL.windOn.(BAL.config{7}).rpsM1));
    
    % Extract all unique angles of attack across configurations
    % allAoA = [];
    % for i = 6:numel(BAL.config)
    %     configName = BAL.config{i};
    %     allAoA = [allAoA, round(BAL.windOn.(configName).AoA)];
    % end
    uniqueAoA = unique(round(BAL.windOn.('propon_de0').AoA));
    
    % Initialize Trimmed_conditions struct
    Trimmed_conditions = struct();

    % Loop over unique angles of attack
    for a = 1:numel(uniqueAoA)
        currentAoA = uniqueAoA(a);

        % Loop over windspeeds
        for w = 1:numel(windspeeds)

            % Loop over RPS settings
            for r = 1:numel(RPS_settings)
                % Initialize data arrays for the current combination of AoA, wind speed, and RPS
                CMpitch_values = zeros(1, numel(elevatorDeflections));
                CL_values = zeros(1, numel(elevatorDeflections));
                CD_values = zeros(1, numel(elevatorDeflections));
                
                % Iterate over configurations to populate the above arrays
                for i = 6:numel(BAL.config)
                    configName = BAL.config{i};
                    
                    % Extract relevant data from the BAL structure
                    CMpitch = BAL.windOn.(configName).CMpitch;
                    CL = BAL.windOn.(configName).CL;
                    CD = BAL.windOn.(configName).CD;
                    AoA = round(BAL.windOn.(configName).AoA);
                    current_RPS = round(BAL.windOn.(configName).rpsM1);
                    current_V = round(BAL.windOn.(configName).V);
                    
                    % Find indices where AoA matches the current loop, along with the current RPS and wind speed
                    idx = find(AoA == currentAoA & current_RPS == RPS_settings(r) & current_V == windspeeds(w));
                    
                    if ~isempty(idx)
                        % Assuming idx always returns a single value per i
                        CMpitch_values(i-5) = CMpitch(idx);
                        CL_values(i-5) = CL(idx);
                        CD_values(i-5) = CD(idx);
                    end
                end
                
                % Field name includes wind speed, RPS setting, and AoA
                fieldName = sprintf('V%dRPS%dAoA%d', windspeeds(w), RPS_settings(r), a);
                
                % Sort elevator deflections and corresponding aerodynamic coefficients
                [sortedDeflections, sortIdx] = sort(elevatorDeflections);
                CMpitch_sorted = CMpitch_values(sortIdx);
                CL_sorted = CL_values(sortIdx);
                CD_sorted = CD_values(sortIdx);
                
                % Store the sorted data in Trimmed_conditions struct
                Trimmed_conditions.(fieldName).AoA = currentAoA;
                Trimmed_conditions.(fieldName).de = sortedDeflections;
                Trimmed_conditions.(fieldName).CM = CMpitch_sorted;
                Trimmed_conditions.(fieldName).CL = CL_sorted;
                Trimmed_conditions.(fieldName).CD = CD_sorted;

                % Calculate trimmed conditions
                % Polynomial fit for CM to find the zero-crossing, which indicates trimmed condition for elevator deflection
                p_CM = polyfit(sortedDeflections, CMpitch_sorted, 2);
                p_CL = polyfit(sortedDeflections, CL_sorted, 1);
                p_CD = polyfit(sortedDeflections, CD_sorted, 2);
                
                de_trim = roots(p_CM); % Find root of CM polynomial fit
                de_trim = de_trim(imag(de_trim) == 0); % Keep only real roots
                
                % Store trimmed conditions in Trimmed_conditions struct
                Trimmed_conditions.(fieldName).de_trim = de_trim;
                if ~isempty(de_trim) % Ensure de_trim is not empty
                    Trimmed_conditions.(fieldName).CL_trim = polyval(p_CL, de_trim);
                    Trimmed_conditions.(fieldName).CD_trim = polyval(p_CD, de_trim);
                else
                    Trimmed_conditions.(fieldName).CL_trim = NaN;
                    Trimmed_conditions.(fieldName).CD_trim = NaN;
                end
                Trimmed_conditions.(fieldName).CM_trim = 0;
                Trimmed_conditions.(fieldName).CL_CD = Trimmed_conditions.(fieldName).CL_trim(2)/Trimmed_conditions.(fieldName).CD_trim(2)
            end
        end
    end
    

   

    %% ------ PLot CL vs CD ------ %%


    % Initialize containers for CL and CD values for plotting
    CL_values_trimmed = cell(1, numel(RPS_settings));
    CD_values_trimmed = cell(1, numel(RPS_settings));
    
    % Collect CL and CD values for plotting
    for r = 1:numel(RPS_settings)
        for w = 1:numel(windspeeds)
            for a = 1:numel(uniqueAoA)
                fieldName = sprintf('V%dRPS%dAoA%d', windspeeds(w), RPS_settings(r), a);
                if isfield(Trimmed_conditions, fieldName)
                    % Assume de_trim has 2 solutions and the second one is the preferred
                    if length(Trimmed_conditions.(fieldName).de_trim) > 1
                        CL_trim = Trimmed_conditions.(fieldName).CL_trim(2);
                        CD_trim = Trimmed_conditions.(fieldName).CD_trim(2);
                    else
                        CL_trim = Trimmed_conditions.(fieldName).CL_trim;
                        CD_trim = Trimmed_conditions.(fieldName).CD_trim;
                    end
                    CL_values_trimmed{r} = [CL_values_trimmed{r}, CL_trim];
                    CD_values_trimmed{r} = [CD_values_trimmed{r}, CD_trim];
                end
            end
        end
    end
    
    % Plotting
    figure;
    hold on;
    colors = lines(numel(RPS_settings)); % Get unique colors for each RPS setting
    for r = 1:numel(RPS_settings)
        plot( CL_values_trimmed{r}, CD_values_trimmed{r}, 'o-', 'MarkerEdgeColor', colors(r, :), 'DisplayName', sprintf('RPS %d', RPS_settings(r)));
    end
    ylabel('CD (Drag Coefficient)');
    xlabel('CL (Lift Coefficient)');
    title('CL vs. CD for Different RPS Settings in trimmed conditions');
    legend('show');
    grid on;
    hold off;

     %% ------ Calculate max L/D ------ %%


    % Initialize arrays to store maximal CL/CD ratios
    % Second Plot: Quadratic Fits and Maximal CL/CD Ratios with CD on y-axis
    figure;
    hold on;
    colors = lines(numel(RPS_settings)); % Unique colors for each RPS setting
    max_CL_CD_info = cell(1, numel(RPS_settings)); % To store text info for annotations
    
    for r = 1:numel(RPS_settings)
        if numel(CD_values_trimmed{r}) > 2 % Ensure there are enough points for quadratic fitting
            % Quadratic fit: CD as y, CL as x
            [p, ~] = polyfit(CL_values_trimmed{r}, CD_values_trimmed{r}, 2);
            
            % Define a fine range of CL values for evaluating the fit and maximizing CL/CD ratio
            CL_fine = linspace(min(CL_values_trimmed{r}), max(CL_values_trimmed{r}), 1000);
            CD_fine = polyval(p, CL_fine);
            
            % Plot the quadratic fit
            plot(CL_fine, CD_fine, 'LineStyle', '-', 'Color', colors(r, :), ...
                 'DisplayName', sprintf('Fit RPS %d', RPS_settings(r)));
            
            % Calculate CL/CD ratio over the fine range and find maximum
            CL_CD_ratio_fine = CL_fine ./ CD_fine;
            [max_ratio, max_idx] = max(CL_CD_ratio_fine);
            
            % Highlight the maximal CL/CD ratio point
            scatter(CL_fine(max_idx), CD_fine(max_idx), 'x', ...
                    'MarkerEdgeColor', colors(r, :), 'LineWidth', 2, ...
                    'DisplayName', sprintf('Optimal RPS %d', RPS_settings(r)));
                    
            % Store maximal CL/CD ratio info for annotation
            max_CL_CD_info{r} = sprintf('RPS %d: Max CL/CD = %.2f at CL = %.2f, CD = %.2f', ...
                                        RPS_settings(r), max_ratio, CL_fine(max_idx), CD_fine(max_idx));
        else
            % Handle cases with insufficient data
            max_CL_CD_info{r} = sprintf('RPS %d: Insufficient data', RPS_settings(r));
        end
    end
    
    xlabel('CL (Lift Coefficient)');
    ylabel('CD (Drag Coefficient)');
    title('Quadratic Fits and Maximal CL/CD Ratio Points for Different RPS Settings');
    legend('show', 'Location', 'best');
    grid on;
    hold off;
    
    % Display maximal CL/CD ratios annotations
    for r = 1:numel(RPS_settings)
        disp(max_CL_CD_info{r});
    end

   
end
