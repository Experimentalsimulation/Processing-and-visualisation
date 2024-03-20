function plotTCvsRPS(BAL)
    % Initialize figure
    figure;

    % Iterate over propon configurations
    %for i = 6:numel(BAL.config)
        % Extract data for the current configuration
    configName = 'propon_de0';
    TC = BAL.windOn.(configName).TC;
    RPS = BAL.windOn.(configName).rpsM1;
    V = BAL.windOn.(configName).V;

    % Plot DeltaCT vs RPS for V = 20
    subplot(2,1,1);
    hold on;
    plot(RPS, TC, 'o-', 'DisplayName', configName);
    xlabel('RPS');
    ylabel('TC');
    title('V = 20');
    legend('show');

    % Plot DeltaCT vs RPS for V = 40
    subplot(2,1,2);
    hold on;
    plot(RPS, TC, 'o-', 'DisplayName', configName);
    xlabel('RPS');
    ylabel('TC');
    title('V = 40');
    legend('show');
    

    % Adjust figure properties
    subplot(2,1,1);
    grid on;
    hold off;

    subplot(2,1,2);
    grid on;
    hold off;

    % Set common legend for both subplots
    legend('Location', 'Best');
end
