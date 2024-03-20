
function modelOffData = readModelOffData(filename)
    % Open the file
    fid = fopen(filename, 'r');

    % Read the first line (assuming it's a script)
    scriptLine = fgetl(fid);

    % Read the second line to get column headers
    headersLine = fgetl(fid);
    headers = strsplit(headersLine, '\t');

    % Initialize struct with empty arrays for each header
    modelOffData = struct();
    for i = 1:length(headers)
        modelOffData.(genvarname(headers{i})) = [];
    end

    % Read data line by line
    line = fgetl(fid);
    while ischar(line)
        % Split line into cells
        cells = strsplit(line, '\t');

        % Assign data to struct
        for i = 1:length(headers)
            % Convert cell content to appropriate data type if needed
            if isnumeric(str2double(cells{i}))
                modelOffData.(genvarname(headers{i})) = [modelOffData.(genvarname(headers{i})), str2double(cells{i})];
            else
                modelOffData.(genvarname(headers{i})){end+1} = cells{i};
            end
        end

        % Read next line
        line = fgetl(fid);
    end

    % Close the file
    fclose(fid);
end
