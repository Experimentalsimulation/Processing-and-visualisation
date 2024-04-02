function plotRPScomp(BAL)

    desired_AoA_sequence = [-5, 0, 5, 10];
    % Loop through each configuration
    
    % Extract relevant data
    i = 6 % Take propon de 0 case
    AoA = BAL.windOn.(BAL.config{i}).AoA;
    CL = BAL.windOn.(BAL.config{i}).CL;
    CD = BAL.windOn.(BAL.config{i}).CD;
    CM = BAL.windOn.(BAL.config{i}).CMpitch;
    V = BAL.windOn.(BAL.config{i}).V;
    RPS = BAL.windOn.(BAL.config{i}).rpsM1;
    V_cor = BAL.windOn.(BAL.config{i}).V_blocked;
    Re = BAL.windOn.(BAL.config{i}).Re;
    AoA = round(AoA)

    % Round speeds to the nearest integer
    rounded_speeds = round(V);
    rounded_correctedSpeeds =  round(V_cor);
    % Group speeds based on tolerance
    unique_speeds = unique(rounded_speeds);
    unique_correctedSpeeds = unique(rounded_correctedSpeeds);
        

    rounded_rps = round(RPS);
    unique_rps = unique(rounded_rps(1:12));
    disp(unique_rps)
    markers = {'o-', 'x-',  'd-', 'v-', 'o-', 's-'}
    % Loop through each unique speed
    for j = 1:length(unique_rps)
        % Extract data for the current speed
        idx_speed = find(rounded_rps == unique_rps(j));
        disp(idx_speed)
        
        % Check if the sequence has exactly 4 data points
        if sum(ismember(desired_AoA_sequence, AoA(idx_speed))) == 4
            % Order the data for the current speed according to the desired sequence
            [~, order_idx] = ismember(desired_AoA_sequence, AoA(idx_speed));

            % Plot CL vs CD for the current speed
            subplot(1, 3, 1);
            plot(CL(idx_speed(order_idx)), CD(idx_speed(order_idx)), markers{j} , 'DisplayName', ['RPS = ', num2str(unique_rps(j))]);
            hold on;
            

            % Plot CL vs AoA for the current speed
            subplot(1, 3, 2);
            plot(AoA(idx_speed(order_idx)), CL(idx_speed(order_idx)), markers{j} , 'DisplayName', ['RPS = ', num2str(unique_rps(j))]);
            hold on;
            
            % Plot CM vs AoA for the current speed
            subplot(1, 3, 3);
            plot(AoA(idx_speed(order_idx)), CM(idx_speed(order_idx)), markers{j} , 'DisplayName', ['RPS = ', num2str(unique_rps(j))]);
            hold on;
            end
    end
    
    %% Add propoff data %%

    i = 1 % Take propon de 0 case
    AoA = BAL.windOn.(BAL.config{i}).AoA;
    CL = BAL.windOn.(BAL.config{i}).CL;
    CD = BAL.windOn.(BAL.config{i}).CD;
    CM = BAL.windOn.(BAL.config{i}).CMpitch;
    V = BAL.windOn.(BAL.config{i}).V;
    V_cor = BAL.windOn.(BAL.config{i}).V_blocked;
    Re = BAL.windOn.(BAL.config{i}).Re;
    AoA = round(AoA)

    % Round speeds to the nearest integer
    rounded_speeds = round(V);
    rounded_correctedSpeeds =  round(V_cor);
    % Group speeds based on tolerance
    unique_speeds = unique(rounded_speeds);
    unique_correctedSpeeds = unique(rounded_correctedSpeeds);
    
    idx_speed = find(rounded_speeds == 40);
    
    % Check if the sequence has exactly 4 data points
    if sum(ismember(desired_AoA_sequence, AoA(idx_speed))) == 4
        % Order the data for the current speed according to the desired sequence
        [~, order_idx] = ismember(desired_AoA_sequence, AoA(idx_speed));

        % Plot CL vs CD for the current speed
        subplot(1, 3, 1);
        plot(CL(idx_speed(order_idx)), CD(idx_speed(order_idx)), markers{j+3} , 'DisplayName', ['Propeller Off']);
        hold on;
        

        % Plot CL vs AoA for the current speed
        subplot(1, 3, 2);
        plot(AoA(idx_speed(order_idx)), CL(idx_speed(order_idx)), markers{j+3} , 'DisplayName', ['Propeller Off']);
        hold on;
        
        % Plot CM vs AoA for the current speed
        subplot(1, 3, 3);
        plot(AoA(idx_speed(order_idx)), CM(idx_speed(order_idx)), markers{j+3} , 'DisplayName', ['Propeller Off']);
        hold on;
        end
    
    % Add labels and legends for CL vs CD
    subplot(1, 3, 1);
    xlabel('CL');
    ylabel('CD');
    % title('CL vs CD for Sequences with 4 Data Points (Ordered by Desired AoA Sequence)');
    legend('Location', 'Best');
    grid on;
    
    % Add labels and legends for CL vs AoA
    subplot(1, 3, 2);
    xlabel('Angle of Attack (degrees)');
    ylabel('CL');
    % title('CL vs AoA for Sequences with 4 Data Points (Ordered by Desired AoA Sequence)');
    legend('Location', 'Best');
    grid on;
    
    % Add labels and legends for CM vs AoA
    subplot(1, 3, 3);
    xlabel('Angle of Attack (degrees)');
    ylabel('CM');
    % title('CM vs AoA for Sequences with 4 Data Points (Ordered by Desired AoA Sequence)');
    legend('Location', 'Best');
    grid on;

end