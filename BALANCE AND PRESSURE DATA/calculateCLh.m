function BAL = calculateCLh(BAL)
    %% Calculate the lift coefficient of the tail
    % Inputs:
    %   BAL - Balance data structure
    %   tail - off data from wind tunnel 
    % Outputs:
    %   BAL - Balance data structure
    %   CLh - lift coefficient of the tail

    % -------- Load data from file --------
    % Open the file
    fileID = fopen('.\DATA\tailoffdata.txt', 'r');

    % Read the first line containing column headers
    headers = fgetl(fileID);
    headerCells = strsplit(headers, '\t');

    % Initialize struct
    tailOffData = struct();

    % Read the data
    line = fgetl(fileID);
    lineCount = 1;

    if fid == -1
    error('Cannot open file.')
    end
    while ischar(line)
        % Split the line into cells
        cells = strsplit(line, '\t');
        
        % Store data in struct
        for i = 1:numel(headerCells)
            % Disregard the second column
            if i ~= 2
                % Check if field exists, if not, create it
                if ~isfield(tailOffData, headerCells{i})
                    tailOffData.(headerCells{i}) = [];
                end
                % Store data in struct
                tailOffData.(headerCells{i})(lineCount) = str2double(cells{i});
            end
        end
        
        % Read next line
        line = fgetl(fileID);
        lineCount = lineCount + 1;
    end

    % Close the file
    fclose(fileID);

    % Display the struct
    disp(tailOffData);

    % -------- Get BAL DATA and Calculate tail data--------

    % Define margin for matching AoA and V
    margin = 0.1;

    % Loop over the BAL data configurations
    for i = 6:numel(BAL.config)
        % Extract data arrays from BAL for the current configuration
        CL = BAL.windOn.(BAL.config{i}).CL;
        CD = BAL.windOn.(BAL.config{i}).CD;
        CM25c = BAL.windOn.(BAL.config{i}).CMpitch25c;
        AoA = BAL.windOn.(BAL.config{i}).AoA;
        V = BAL.windOn.(BAL.config{i}).V;
        
        % Initialize arrays to store calculated differences
        CLh = zeros(size(CL));
        CDh = zeros(size(CD));
        CM25ch = zeros(size(CM25c));
        
        % Loop over each data point in the configuration
        for k = 1:numel(CL)
            % Initialize variables to store matched indices and differences
            matchIndex = [];
            diffCL = [];
            diffCD = [];
            diffCM25c = [];
            
            % Loop over tailOffData to find matching data points
            for j = 1:numel(tailOffData.V)
                % Check for matching AoA and V within margin
                if abs(AoA(k) - tailOffData.AoA(j)) <= margin && abs(V(k) - tailOffData.V(j)) <= margin
                    % Store matched index and differences
                    matchIndex = [matchIndex, j];
                    diffCL = [diffCL, CL(k) - tailOffData.CL(j)];
                    diffCD = [diffCD, CD(k) - tailOffData.CD(j)];
                    diffCM25c = [diffCM25c, CM25c(k) - tailOffData.CM25c(j)];
                    % Warning if multiple matches found
                    if numel(matchIndex) > 1
                        warning('Multiple matches found for AoA = %.2f and V = %.2f', AoA(k), V(k));
                    end
                end
            end
            
            % Calculate average differences if matches found
            if ~isempty(matchIndex)
                CLh(k) = mean(diffCL);
                CDh(k) = mean(diffCD);
                CM25ch(k) = mean(diffCM25c);
            end
        end
        
        % Store calculated differences in BAL struct
        BAL.windOn.(BAL.config{i}).CLh = CLh;
        BAL.windOn.(BAL.config{i}).CDh = CDh;
        BAL.windOn.(BAL.config{i}).CM25ch = CM25ch;
    end

end