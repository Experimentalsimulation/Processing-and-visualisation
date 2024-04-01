function BAL = deleteDataPoint(BAL)
    fields = fieldnames(BAL.windOn.('propon_de25'));
    for i = 1:numel(fields)
        BAL.windOn.('propon_de25').(fields{i})(1) = [];
    end
end