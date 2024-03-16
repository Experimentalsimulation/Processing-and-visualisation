function correctedBAL = correctBALData(BAL, modelOffData)
    % Initialize the corrected struct
    correctedBAL = BAL;

    % Iterate over configurations in BAL
    for i = 1:numel(BAL.config)
        % Extract relevant data from BAL
        AoA_BAL = BAL.windOn.(BAL.config{i}).AoA;
        CL_BAL = BAL.windOn.(BAL.config{i}).CL;
        CD_BAL = BAL.windOn.(BAL.config{i}).CD;
        CM_BAL = BAL.windOn.(BAL.config{i}).CMpitch;

        % Iterate over AoA values in BAL
        for j = 1:numel(AoA_BAL)
            % Find matching AoA value in modelOffData
            matching_idx = abs(modelOffData.AoA - AoA_BAL(j)) < 0.1;

            % If a match is found, subtract the corresponding data from BAL
            if any(matching_idx)
                % Subtract data from modelOffData
                CL_BAL(j) = CL_BAL(j) - modelOffData.CL(matching_idx);
                CD_BAL(j) = CD_BAL(j) - modelOffData.CD(matching_idx);
                CM_BAL(j) = CM_BAL(j) - modelOffData.CMpitch(matching_idx);
            end
        end

        % Update corrected struct with modified data
        correctedBAL.windOn.(BAL.config{i}).CL = CL_BAL;
        correctedBAL.windOn.(BAL.config{i}).CD = CD_BAL;
        correctedBAL.windOn.(BAL.config{i}).CMpitch = CM_BAL;
    end
end
