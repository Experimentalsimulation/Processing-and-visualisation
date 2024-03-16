function plotData(BAL)
    % Create figures for CL vs CD, CL vs AoA, and CM vs AoA
    figure;
    
    % Set a speed tolerance (adjust as needed)
    speed_tolerance = 2; % in m/s
    desired_AoA_sequence = [-5, 0, 5, 10];
    % Loop through each configuration
    for i = 1:numel(BAL.config)
        % Extract relevant data
        AoA = BAL.windOn.(BAL.config{i}).AoA;
        CL = BAL.windOn.(BAL.config{i}).CL;
        CD = BAL.windOn.(BAL.config{i}).CD;
        CM = BAL.windOn.(BAL.config{i}).CMpitch;
        V = BAL.windOn.(BAL.config{i}).V;
        AoA = round(AoA)
        % Round speeds to the nearest integer
        rounded_speeds = round(V);
    
        % Group speeds based on tolerance
        unique_speeds = unique(rounded_speeds);
    
        % Loop through each unique speed
        for j = 1:length(unique_speeds)
            % Extract data for the current speed
            idx_speed = find(rounded_speeds == unique_speeds(j));
    
            % Check if the sequence has exactly 4 data points
            if sum(ismember(desired_AoA_sequence, AoA(idx_speed))) == 4
                % Order the data for the current speed according to the desired sequence
                [~, order_idx] = ismember(desired_AoA_sequence, AoA(idx_speed));
    
                % Plot CL vs CD for the current speed
                subplot(1, 3, 1);
                plot(CL(idx_speed(order_idx)), CD(idx_speed(order_idx)), 'o-', 'DisplayName', [BAL.config{i}, ', V = ', num2str(unique_speeds(j)), ' m/s']);
                hold on;
    
                % Plot CL vs AoA for the current speed
                subplot(1, 3, 2);
                plot(AoA(idx_speed(order_idx)), CL(idx_speed(order_idx)), 'o-', 'DisplayName', [BAL.config{i}, ', V = ', num2str(unique_speeds(j)), ' m/s']);
                hold on;
    
                % Plot CM vs AoA for the current speed
                subplot(1, 3, 3);
                plot(AoA(idx_speed(order_idx)), CM(idx_speed(order_idx)), 'o-', 'DisplayName', [BAL.config{i}, ', V = ', num2str(unique_speeds(j)), ' m/s']);
                hold on;
            end
        end
    end
    
    % Add labels and legends for CL vs CD
    subplot(1, 3, 1);
    xlabel('CL');
    ylabel('CD');
    title('CL vs CD for Sequences with 4 Data Points (Ordered by Desired AoA Sequence)');
    legend('Location', 'Best');
    grid on;
    
    % Add labels and legends for CL vs AoA
    subplot(1, 3, 2);
    xlabel('Angle of Attack (degrees)');
    ylabel('CL');
    title('CL vs AoA for Sequences with 4 Data Points (Ordered by Desired AoA Sequence)');
    legend('Location', 'Best');
    grid on;
    
    % Add labels and legends for CM vs AoA
    subplot(1, 3, 3);
    xlabel('Angle of Attack (degrees)');
    ylabel('CM');
    title('CM vs AoA for Sequences with 4 Data Points (Ordered by Desired AoA Sequence)');
    legend('Location', 'Best');
    grid on;

end
