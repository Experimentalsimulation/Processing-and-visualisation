function [MIC_track_propon, MIC_track_propoff] = Get_MIC_track(MIC,fn,opp)


%OASPL and corrections:

prop_track = [1,1,1,1,1,0,0,0,0,0];
de_track = [0,-10,10,20,25,0,-10,10,20,25];

n = 0;

for i = 1:length(fn)

    MIC_fn = MIC{i};

    prop = prop_track(i);
    de = de_track(i);

    for j = 1:length(MIC_fn.f)

        n = n+1;

        fieldNames = fieldnames(MIC_fn);

        for k = 1:length(fieldNames)
            MIC_track(n).MIC.(fieldNames{k}) = MIC_fn.(fieldNames{k}){j};
        end


        MIC_track(n).de = de;
        MIC_track(n).prop = prop;
    

        
        V_inf = opp{i}.vInf(j);
        alpha = opp{i}.AoA(j);

        if isinf(opp{i}.J_M1(j))
            J = 0;
        else
            J = mean([opp{i}.J_M1(j),opp{i}.J_M2(j)]);
        end

        RPS = mean([opp{i}.RPS_M1(j),opp{i}.RPS_M2(j)]);


        MIC_track(n).V_inf = round(V_inf, 0);
        MIC_track(n).J = round(J, 1);    %DO not change this, otherwise the datapoints will mix together
        MIC_track(n).RPS = round(RPS,1);
        MIC_track(n).alpha = round(alpha, 0);
        
    end


end




%Sort the datapoints in pahabetical-like order

% fieldNames = fieldnames(MIC_track);
fieldNames = {'alpha','J','de','V_inf','prop'};

for i= 1:length(fieldNames)
    [~, idx] = sort([MIC_track.(fieldNames{i})]); % Sort based on 'prop' field
    MIC_track = MIC_track(idx);
end








%Splits prop off and prop on points into two different structs
a = 1;
b = 1;
for i = 1:length(MIC_track)
    if MIC_track(i).prop == 0
        MIC_track_propoff(a) = MIC_track(i);
        a = a +1;
    else
        MIC_track_propon(b) = MIC_track(i);
        b = b+1;
    end
end


end