% Given data points
x = [1, 2, 3];
y = [1, 3, 2];

% Fit a quadratic curve to the data
p = polyfit(x, y, 2); % Quadratic polynomial coefficients

% New x-value for extrapolation
x_new = 4;

% Extrapolate y-value using the quadratic function
y_new = polyval(p, x_new);

% Plot original data points
plot(x, y, 'o', 'MarkerSize', 10, 'DisplayName', 'Data Points');
hold on;

% Plot the fitted quadratic curve
x_fit = linspace(min(x), max(x), 100); % Generate x-values for the curve
y_fit = polyval(p, x_fit); % Evaluate the quadratic function
plot(x_fit, y_fit, 'LineWidth', 2, 'DisplayName', 'Fitted Quadratic Curve');

% Plot the extrapolated point
plot(x_new, y_new, 'rx', 'MarkerSize', 10, 'DisplayName', 'Extrapolated Point');

% Add labels and legend
xlabel('X');
ylabel('Y');
title('Quadratic Extrapolation');
legend('Location', 'best');
grid on;
hold off;