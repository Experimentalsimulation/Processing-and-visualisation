function PlotReynoldsCom(BAL)
    desired_AoA_sequence = [-5, 0, 5, 10];
    % Loop through each configuration
    
    % Extract relevant data
    i = 6 % Take propon de 0 case where wee tested both at V= 20 and V = 40
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

    markers = {'o-', 'x-'}
    % Loop through each unique speed
    for j = 1:length(unique_speeds)
        % Extract data for the current speed
        idx_speed = find(rounded_speeds == unique_speeds(j));
        disp(idx_speed)
        Re_numb = [Re(13),Re(1)]
        disp(Re_numb)
        % if j == 1 
        %     Re_numb = Re(1)
        %     disp('Yes!')
        % else
        %     Re_numb = Re(13)
        %     disp('YES!!!!')
        % Check if the sequence has exactly 4 data points
        if sum(ismember(desired_AoA_sequence, AoA(idx_speed))) == 4
            % Order the data for the current speed according to the desired sequence
            [~, order_idx] = ismember(desired_AoA_sequence, AoA(idx_speed));

            % Plot CL vs CD for the current speed
            subplot(1, 3, 1);
            plot(CL(idx_speed(order_idx)), CD(idx_speed(order_idx)), markers{j} , 'DisplayName', ['Re = ', num2str(round(Re_numb(j)/100000,2)), 'E5, V = ', num2str(unique_correctedSpeeds(j)), ' m/s']);
            hold on;
            

            % Plot CL vs AoA for the current speed
            subplot(1, 3, 2);
            plot(AoA(idx_speed(order_idx)), CL(idx_speed(order_idx)), markers{j} , 'DisplayName', ['Re = ', num2str(round(Re_numb(j)/100000,2)), 'E5, V = ', num2str(unique_correctedSpeeds(j)), ' m/s']);
            hold on;
            
            % Plot CM vs AoA for the current speed
            subplot(1, 3, 3);
            plot(AoA(idx_speed(order_idx)), CM(idx_speed(order_idx)), markers{j} , 'DisplayName', ['Re = ', num2str(round(Re_numb(j)/100000,2)), 'E5, V = ', num2str(unique_correctedSpeeds(j)), ' m/s']);
            hold on;
            end
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
