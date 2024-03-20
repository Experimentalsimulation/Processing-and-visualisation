function coefficients = get_abc_plot_Cl2_vs_Cd(cl_squared_values, cd_values)
    % Plots Cl^2 vs Cd and applies a polynomial line of best fit of the
    % form a + bx + cx^2 where x = Cl^2.
    % Returns the coefficients a, b and c.

    % Fit a polynomial of degree 2 (a + bx + cx^2) to the data
    degree = 2;
    coefficients = polyfit(cl_squared_values, cd_values, degree);

    % Generate x values for the polynomial line
    x_values = linspace(min(cl_squared_values), max(cl_squared_values), 100);

    % Calculate corresponding y values using the polynomial function
    y_values = polyval(coefficients, x_values);

    % Plot the scatter plot
    scatter(cl_squared_values, cd_values, 'o', 'MarkerFaceColor', 'blue', 'MarkerEdgeColor', 'blue');
    hold on;

    % Plot the polynomial line of best fit
    plot(x_values, y_values, 'red', 'LineWidth', 2);

    % Set labels and title
    xlabel('CL^2_unc');
    ylabel('CD_unc');
    title('CL^2_unc vs CD_unc');

    % Add legend
    legend('Data Points', 'Polynomial Fit');

    % Show grid
    grid on;

    % Show plot
    hold off;
end