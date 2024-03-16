function BAL = calculateDeltaCT(BAL,D,S)
    % Initialize cell arrays to store CT values for propoff (first five) and propon (last five) configurations
    propoffCT = {};
    proponCT = {};
    SP = pi * (1/2) * D^2;
    
    % Iterate over configurations in BAL
    for i = 1:numel(BAL.config)
        % Extract CT values from BAL
        CT = BAL.windOn.(BAL.config{i}).CT;
        AoA = BAL.windOn.(BAL.config{i}).AoA;
        V = BAL.windOn.(BAL.config{i}).V;
        q = BAL.windOn.(BAL.config{i}).q;

        % Store CT values in the appropriate cell array based on configuration index
        if i <= 5
            propoffCT{end+1} = struct('AoA', AoA, 'V', V, 'CT', CT);
        else
            proponCT{end+1} = struct('AoA', AoA, 'V', V, 'CT', CT, 'q', q);
        end
    end
    display(proponCT{1}(1))
    display(proponCT{1}.CT(1))
    display(propoffCT{1})
    % Initialize cell array to store DeltaCT values
    DeltaCT = cell(1, numel(proponCT));
    T = cell(1, numel(proponCT));
    TC = cell(1, numel(proponCT));

    % Calculate DeltaCT for each configuration
    for i = 1:numel(proponCT)
        % Initialize array to store subtracted CT values
        subtractedCT = [];
        TC_list = []
        T_list = []

        % Iterate through proponCT data points
        for j = 1:length(proponCT{i}.CT)
            datapoint = struct('AoA', proponCT{i}.AoA(j), 'V', proponCT{i}.V(j), 'CT',  proponCT{i}.CT(j))
            % Find matching data point in propoffCT based on AoA and V
            matching_idx = findMatchingData(datapoint, propoffCT{i});

            % If a match is found, subtract CT values
            if ~isempty(matching_idx)
                delta =  proponCT{i}.CT(j) - propoffCT{i}.CT(matching_idx);
                T_ind =  proponCT{i}.q(j) * S * delta ;
                TC_ind = T_ind / (2* proponCT{i}.q(j)*SP)
                subtractedCT(end+1) = delta;
                TC_list(end+1) = TC_ind;
                T_list(end+1) = T_ind;
            end
        end

        % Store subtracted CT values as DeltaCT for this configuration
        DeltaCT{i} = subtractedCT;
        T{i} = T_list;
        TC{i} = TC_list
    end

    % Add DeltaCT as a new field in the BAL struct for propon configurations
    for i = 1:numel(proponCT)
        configName = BAL.config{i+5}; % Assuming first five configs are stored before last five configs
        BAL.windOn.(configName).DeltaCT = DeltaCT{i};
        BAL.windOn.(configName).T = T{i};
        BAL.windOn.(configName).TC = TC{i};        
    end
end

function matching_idx = findMatchingData(dataPoint, dataArray)
    % Initialize matching index
    matching_idx = [];
    % display(dataPoint)
    display(dataArray.AoA)
    display(dataArray.V)
    % Iterate through dataArray to find matching data point
    for i = 1:length(dataArray.AoA)
        % Check if AoA and V values match within a tolerance
        matching_AoA = all(abs(dataArray.AoA(i) - dataPoint.AoA) < 0.1);
        matching_V = all(abs(dataArray.V(i) - dataPoint.V) < 0.1);
        display(matching_AoA)
        display(matching_V)
        % If both AoA and V values match, set matching index and break the loop
        if matching_AoA && matching_V
            display(i)
            matching_idx = i;
            break;
        end
    end
end
