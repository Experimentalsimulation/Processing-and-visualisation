function [tail_off_20, tail_off_40] = tailoff(tailoffdata)
% Read tail off data extract 20 m/s and 40 m/s data in two tables

% Read the file using readtable
CLwing = readtable(tailoffdata, 'Delimiter', '\t');
CLwing = sortrows(CLwing,'V');
CLwingV20 = CLwing(CLwing.V >=  18 & CLwing.V < 22, :);
CLwingV40 = CLwing(CLwing.V >= 38 & CLwing.V < 42, :);

tail_off_20 = removevars(CLwingV20, {'V', 'AoS'});
tail_off_40 = removevars(CLwingV40, {'V', 'AoS'});

tail_off_40 = sortrows(tail_off_40, "AoA");
tail_off_20 = sortrows(tail_off_20,"AoA");
end

