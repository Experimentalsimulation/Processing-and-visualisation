function [] = blockage(BAL)
 % Iterate over configurations in BAL
    for i = 1:numel(BAL.config)
        % Extract CT values from BAL
        
        CT = BAL.windOn.(BAL.config{i}).CT; %  This should be called Tc
        V = BAL.windOn.(BAL.config{i}).V;

        CL = BAL.windOn.(BAL.config{i}).CL;
        CD = BAL.windOn.(BAL.config{i}).CD;
        CM = BAL.windOn.(BAL.config{i}).CM;


        eps_solid = solidblockage(V);
        eps_wake = 0; % function for maskells method Not Implemented
        disp('Maskells method in function Blockage is not yet implemented')
        eps_reg = Regenblockage(CT);
        epsilon = eps_solid + eps_wake + eps_reg;
        
        BAL.windOn.(BAL.config{i}).V_blocked = V * (1 + epsilon);
        BAL.windOn.(BAL.config{i}).q_blocked = q * (1 + epsilon)^2;

        BAL.windOn.(BAL.config{i}).CL_blocked = CL * (1 + epsilon)^-2;
        BAL.windOn.(BAL.config{i}).CD_blocked = CD * (1 + epsilon)^-2;
        BAL.windOn.(BAL.config{i}).CM_blocked = CM * (1 + epsilon)^-2;
        BAL.windOn.(BAL.config{i}).CT_blockd = CT * (1 + epsilon)^-2;

    end 
end