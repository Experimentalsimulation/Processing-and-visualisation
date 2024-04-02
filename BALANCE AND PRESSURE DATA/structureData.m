function blockage_and_lift_corrected_BAL = structureData(BAL)
    
    blockage_and_lift_corrected_BAL = BAL
    for i = 1: numel(BAL.config)
        % update blockage V, CL, CD, q, TC, CMpitch, CMpitch25c
        blockage_and_lift_corrected_BAL.windOn.(BAL.config{i}).V_uncorrected = BAL.windOn.(BAL.config{i}).V;
        blockage_and_lift_corrected_BAL.windOn.(BAL.config{i}).CL_uncorrected = BAL.windOn.(BAL.config{i}).CL;
        blockage_and_lift_corrected_BAL.windOn.(BAL.config{i}).CD_uncorrected = BAL.windOn.(BAL.config{i}).CD;
        blockage_and_lift_corrected_BAL.windOn.(BAL.config{i}).q_uncorrected = BAL.windOn.(BAL.config{i}).q;
        
        blockage_and_lift_corrected_BAL.windOn.(BAL.config{i}).CMpitch_uncorrected = BAL.windOn.(BAL.config{i}).CMpitch;
        blockage_and_lift_corrected_BAL.windOn.(BAL.config{i}).CMpitch25c_uncorrected = BAL.windOn.(BAL.config{i}).CMpitch25c;
        % update blockage V, CL, CD, q, TC, CMpitch, CMpitch25c
        %blockage_and_lift_corrected_BAL.windOn.(BAL.config{i}).V = reshape(BAL.windOn.(BAL.config{i}).V_blocked, [], 1);
        blockage_and_lift_corrected_BAL.windOn.(BAL.config{i}).CL = reshape(BAL.windOn.(BAL.config{i}).CL_blocked, [], 1);
        blockage_and_lift_corrected_BAL.windOn.(BAL.config{i}).CD = reshape(BAL.windOn.(BAL.config{i}).CD_blocked, [], 1);
        blockage_and_lift_corrected_BAL.windOn.(BAL.config{i}).q = reshape(BAL.windOn.(BAL.config{i}).q_blocked, [], 1);
        
        blockage_and_lift_corrected_BAL.windOn.(BAL.config{i}).CMpitch = reshape(BAL.windOn.(BAL.config{i}).CM_blocked, [], 1);
        blockage_and_lift_corrected_BAL.windOn.(BAL.config{i}).CMpitch25c = reshape(BAL.windOn.(BAL.config{i}).CM25c_blocked, [], 1);
        % update for lift interferance: AoA, CMpitch, CD
        blockage_and_lift_corrected_BAL.windOn.(BAL.config{i}).AoA = reshape(BAL.windOn.(BAL.config{i}).AoA_bc, [], 1);
        blockage_and_lift_corrected_BAL.windOn.(BAL.config{i}).CMpitch = reshape(BAL.windOn.(BAL.config{i}).CM_bc, [], 1);
        blockage_and_lift_corrected_BAL.windOn.(BAL.config{i}).CD = reshape(BAL.windOn.(BAL.config{i}).CD_bc, [], 1);

        if i > 5 
            blockage_and_lift_corrected_BAL.windOn.(BAL.config{i}).TC_uncorrected = BAL.windOn.(BAL.config{i}).TC;
            blockage_and_lift_corrected_BAL.windOn.(BAL.config{i}).TC = BAL.windOn.(BAL.config{i}).TC_blocked;
        end
end

