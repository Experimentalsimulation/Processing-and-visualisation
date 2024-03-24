function [cl_squared_values, cd_values] = get_Cl2_and_Cd(filename, v_interested)
    % Gets lists of data for Cl^2 vs Cd for velocity v
    cl_squared_values = [];
    cd_values = [];
    
    % Open the file
    fid = fopen(filename, 'r');
    
    % Read the first line to get column names
    columns = strsplit(fgetl(fid));
    
    % Find the indices of CL, CD, and V
    cl_index = find(ismember(columns, 'CL'));
    cd_index = find(ismember(columns, 'CD'));
    v_index = find(ismember(columns, 'V'));
    
    % Now read the rest of the file
    tline = fgetl(fid);
    count = 0;
    i = 0;
    while ischar(tline)
        % Split the line into values
        values = strsplit(tline);
        
        % Try to convert values to floats
        try
            cl_value = str2double(values{cl_index});
            cd_value = str2double(values{cd_index});
            v_value = str2double(values{v_index});
            
            % Only append value if the velocity of DPN is the one of interest
            
            i = i+1;
            if abs(v_value - v_interested) <= 5
                cl_squared_values = [cl_squared_values, cl_value^2];
                cd_values = [cd_values, cd_value];
            else
                count = count + 1;
            end

           
            
        % If not floats just skip
        catch
            disp('values could not be converted to floats get_Cl2_and_Cd.m line 26-28')
            % Skip this line
        end
        
        % Read the next line
        tline = fgetl(fid);
    end
    
    if i - count < 4
        warning(['This file (' filename ') has not enough data points (' num2str(i-count) ') at velocity (' num2str(v_interested) ') Maskells method correction can not be applied'])
        cl_squared_values = [];
        cd_values =[];
    end
    

    
    % Close the file
    fclose(fid);
end