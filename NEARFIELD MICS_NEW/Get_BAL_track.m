%Function extrcts the Ct values from the BAL.mat data, and assigns the
%correct values for each measurement point



function [BAL_track_propon, BAL_track_propoff] = Get_BAL_track()

    load('correctedBAL_windOn.mat')

    n = 0;

    
    BAL_fieldNames = fieldnames(BAL);    %Input the field names we actually want to obtain
    prop_track = [0,0,0,0,0,1,1,1,1,1];
    de_track = [0,10,20,25,-10,0,10,20,25,-10];

    for i = 1:length(prop_track)

        BAL_fn = BAL.(BAL_fieldNames{i});
    
        prop = prop_track(i);
        de = de_track(i);
    
        fieldNames = {'AoA','J_M1','J_M2','V','rpsM1','rpsM2','CT'};

        for j = 1:length(BAL_fn.run)
    
            n = n+1;
    
    
            for k = 1:length(fieldNames)
                BAL_track_raw(n).(fieldNames{k}) = BAL_fn.(fieldNames{k})(j);
            end


            BAL_track(n).de = de;
            BAL_track(n).prop = prop;

            BAL_track(n).V_inf =  round(real(BAL_track_raw(n).V),0);


            if isinf(BAL_track_raw(n).J_M1)
                BAL_track(n).J = 0;
            else
                BAL_track(n).J = round(real(mean([BAL_track_raw(n).J_M1,BAL_track_raw(n).J_M1])),1);
            end

            

            BAL_track(n).RPS = round(mean([BAL_track_raw(n).rpsM1,BAL_track_raw(n).rpsM1]),1);

            BAL_track(n).alpha = round(BAL_track_raw(n).AoA,0);

            BAL_track(n).CT = BAL_track_raw(n).CT;
    

        
          


        end


    end
    
    
    %Sort the datapoints in pahabetical-like order
    
    % fieldNames = fieldnames(MIC_track);
    fieldNames = {'alpha','J','de','V_inf','prop'};
    
    for i= 1:length(fieldNames)
        [~, idx] = sort([BAL_track.(fieldNames{i})]); % Sort based on 'prop' field
        BAL_track = BAL_track(idx);
    end
    
    
    %Splits prop off and prop on points into two different structs
    a = 1;
    b = 1;
    for i = 1:length(BAL_track)
        if BAL_track(i).prop == 0
            BAL_track_propoff(a) = BAL_track(i);
            a = a +1;
        else
            BAL_track_propon(b) = BAL_track(i);
            b = b+1;
        end
    end


end