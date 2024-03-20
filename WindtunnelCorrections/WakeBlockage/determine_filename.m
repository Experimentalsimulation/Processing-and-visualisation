function filename = determine_filename(de, PropOn, WindOn)
    % Returns the name of the filename based on de, PropOn, and WindOn
    
    filename = 'C:/Users/PC/Documents/AA TU Delft/MSc AE jaar 1/Q2&3 Experimental Simulations/Group04/BAL/unc';
    
    % Add propson or propsoff to filename string
    if PropOn == true
        filename = strcat(filename, '_propon');
    elseif PropOn == false
        filename = strcat(filename, '_propoff');
    else
        error('The PropOn variable may only be true or false');
    end
    
    % Add de to filename string
    if de == -10
        filename = strcat(filename, '_demin10');
    else
        filename = strcat(filename, sprintf('_de%d', de));
    end
    
    % Add windoff to filename string
    if WindOn == false
        filename = strcat(filename, '_windoff');
    end
    
    % Add .txt to filename
    filename = strcat(filename, '.txt');
end