function [cl2_values, cd_values] = get_cl2_cd(BAL, v_interest, rps_interest, propon, de)
    % Returns cl and cd values for given velocity, rps, prop configuration
    % and flap deflection
    
    % initialise the outputs
    cl_values = [];
    cd_values = [];

    % Set velocity and rps tolerances (adjust as needed)
    vel_tol = 2; % in m/s
    rps_tol = 2; % in m/s

    % determine struct path
    if propon
        if de == -10
            argument = sprintf('propon_demin10');
        else
            argument = sprintf('propon_de%d', de);
        end
    else
        if de == -10
            argument = sprintf('propoff_demin10');
        else
            argument = sprintf('propoff_de%d', de);
        end
    end
    
    % extract relevant data
    rps = BAL.windOn.(argument).rpsM1;
    CL = BAL.windOn.(argument).CL;
    CD = BAL.windOn.(argument).CD;
    V = BAL.windOn.(argument).V;
    
    % get length that we will iterate over
    [numrows, ~] = size(rps);
    
    % iterate to select relevant data
    for i = 1:numrows
        if abs(V(i)-v_interest)<=vel_tol && abs(rps(i)-rps_interest)<=rps_tol
            cl_values = [cl_values; CL(i)];
            cd_values = [cd_values; CD(i)];
        end
    end

    % we want the Cl^2 values
    cl2_values = cl_values.^2;
    
    end






