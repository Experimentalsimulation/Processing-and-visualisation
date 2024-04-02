function blockage_and_lift_corrected_BAL = structureData(BAL)

    for i = 1: numel(BAL.config)
        % update blockage V, CL, CD, q, TC, CMpitch, CMpitch25c
        blockage_and_lift_corrected_BAL.windOn.(BAL.config(i)).V_uncorrected = BAL.windOn.(BAL.config(i)).V;
        blockage_and_lift_corrected_BAL.windOn.(BAL.config(i)).CL_uncorrected = BAL.windOn.(BAL.config(i)).CL;
        blockage_and_lift_corrected_BAL.windOn.(BAL.config(i)).CD_uncorrected = BAL.windOn.(BAL.config(i)).CD;
        blockage_and_lift_corrected_BAL.windOn.(BAL.config(i)).q_uncorrected = BAL.windOn.(BAL.config(i)).q;
        blockage_and_lift_corrected_BAL.windOn.(BAL.config(i)).TC_uncorrected = BAL.windOn.(BAL.config(i)).TC;
        blockage_and_lift_corrected_BAL.windOn.(BAL.config(i)).CMpitch_uncorrected = BAL.windOn.(BAL.config(i)).CMpitch;
        blockage_and_lift_corrected_BAL.windOn.(BAL.config(i)).CMpitch25c_uncorrected = BAL.windOn.(BAL.config(i)).CMpitch25c;
        % update blockage V, CL, CD, q, TC, CMpitch, CMpitch25c
        blockage_and_lift_corrected_BAL.windOn.(BAL.config(i)).V = BAL.windOn.(BAL.config(i)).V_blocked;
        blockage_and_lift_corrected_BAL.windOn.(BAL.config(i)).CL = BAL.windOn.(BAL.config(i)).CL_blocked;
        blockage_and_lift_corrected_BAL.windOn.(BAL.config(i)).CD = BAL.windOn.(BAL.config(i)).CD_blocked;
        blockage_and_lift_corrected_BAL.windOn.(BAL.config(i)).q = BAL.windOn.(BAL.config(i)).q_blocked;
        blockage_and_lift_corrected_BAL.windOn.(BAL.config(i)).TC = BAL.windOn.(BAL.config(i)).TC_blocked;
        blockage_and_lift_corrected_BAL.windOn.(BAL.config(i)).CMpitch = BAL.windOn.(BAL.config(i)).CM_blocked;
        blockage_and_lift_corrected_BAL.windOn.(BAL.config(i)).CMpitch25c = BAL.windOn.(BAL.config(i)).CM25c_blocked;
        % update for lift interferance: AoA, CMpitch, CD
        blockage_and_lift_corrected_BAL.windOn.(BAL.config(i)).AoA = BAL.windOn.(BAL.config(i)).AoA_bc;
        blockage_and_lift_corrected_BAL.windOn.(BAL.config(i)).CMpitch = BAL.windOn.(BAL.config(i)).CM_bc;
        blockage_and_lift_corrected_BAL.windOn.(BAL.config(i)).CD = BAL.windOn.(BAL.config(i)).CD_bc;
end

