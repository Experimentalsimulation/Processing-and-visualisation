%% Initialization
% clear workspace, figures, command window
clear 
close all
clc

%% Inputs

% define root path on disk where data is stored
diskPath = './DATA';

% Load the data
data = readtable('raw_propon_zero.txt');

% Sort the data based on Angle of Attack (Alpha)
data_sorted = sortrows(data, 'Alpha');

% Extract relevant columns
Alpha = data_sorted.Alpha;
B_columns = data_sorted{:, {'B1', 'B2', 'B3', 'B4', 'B5', 'B6'}};

% Plot the original data
figure;
plot(Alpha, B_columns, 'o-', 'DisplayName', 'Original Data');
xlabel('Alpha (degrees)');
ylabel('B Columns');
title('Original Data (Sorted)');
legend('B1', 'B2', 'B3', 'B4', 'B5', 'B6', 'Location', 'best');
grid on;

% Perform quadratic interpolation
num_points = numel(Alpha);
interpolated_values = zeros((num_points - 1) * 9, size(B_columns, 2));
interpolated_alphas = zeros((num_points - 1) * 9, 1);
idx = 1;
for i = 1:num_points - 1
    x = [Alpha(i), Alpha(i+1)];
    for col = 1:size(B_columns, 2)
        y = [B_columns(i, col), B_columns(i+1, col)];
        p = polyfit(x, y, 2); % Quadratic fit
        alpha_interp = linspace(Alpha(i), Alpha(i+1), 10); % Interpolated alphas
        B_interp = polyval(p, alpha_interp); % Interpolated B values
        interpolated_alphas(idx:idx+8) = alpha_interp(2:end-1); % Exclude the endpoints
        interpolated_values(idx:idx+8, col) = B_interp(2:end-1); % Exclude the endpoints
    end
    idx = idx + 9;
end

% Combine the sorted data with the interpolated values
Alpha_combined = [Alpha; interpolated_alphas];
B_columns_combined = [B_columns; interpolated_values];

% Perform quadratic extrapolation for each column
x = 1:numel(Alpha_combined); % Data point indices
extrapolated_values = zeros(1, size(B_columns_combined, 2));
for i = 1:size(B_columns_combined, 2)
    p = polyfit(x, B_columns_combined(:, i), 2); % Quadratic fit
    extrapolated_values(i) = polyval(p, num_points + 1); % Extrapolate at Angle 10
end

% Create a new row for extrapolated values
new_row = [NaN(1, size(data_sorted, 2) - 2), extrapolated_values];

% Convert the new row into a table
new_data_row = array2table(new_row, 'VariableNames', data.Properties.VariableNames(3:end));

% Concatenate the new row with the sorted table
new_data_sorted = [data_sorted; new_data_row];

% Plot the data after extrapolation and interpolation
figure;
plot(Alpha_combined, [B_columns_combined; extrapolated_values], 'o-', 'DisplayName', 'Data with Extrapolation and Interpolation');
xlabel('Alpha (degrees)');
ylabel('B Columns');
title('Data with Extrapolation and Interpolation (Sorted)');
legend('B1', 'B2', 'B3', 'B4', 'B5', 'B6', 'Location', 'best');
grid on;

% Display the extrapolated values
disp('Extrapolated values:');
disp(extrapolated_values);

% Save the updated data to a new file
writetable(new_data_sorted, 'raw_propon_zero_with_extrapolation_interpolation_sorted.txt');


% % get indices balance and pressure data files
% [idxB,idxP] = SUP_getIdx;
% 
% filename = 'BAL/raw_propon_zero.txt';
% fid  = fopen(filename);
% 
% 
% % Given data points
% x = [1, 2, 3];
% y = [1, 3, 2];
% 
% % Fit a quadratic curve to the data
% p = polyfit(x, y, 2); % Quadratic polynomial coefficients
% 
% % New x-value for extrapolation
% x_new = 4;
% 
% % Extrapolate y-value using the quadratic function
% y_new = polyval(p, x_new);
% 
% % Plot original data points
% plot(x, y, 'o', 'MarkerSize', 10, 'DisplayName', 'Data Points');
% hold on;
% 
% % Plot the fitted quadratic curve
% x_fit = linspace(min(x), max(x), 100); % Generate x-values for the curve
% y_fit = polyval(p, x_fit); % Evaluate the quadratic function
% plot(x_fit, y_fit, 'LineWidth', 2, 'DisplayName', 'Fitted Quadratic Curve');
% 
% % Plot the extrapolated point
% plot(x_new, y_new, 'rx', 'MarkerSize', 10, 'DisplayName', 'Extrapolated Point');
% 
% % Add labels and legend
% xlabel('X');
% ylabel('Y');
% title('Quadratic Extrapolation');
% legend('Location', 'best');
% grid on;
% hold off;