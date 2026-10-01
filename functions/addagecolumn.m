function T = addagecolumn(T)

headers = T.Properties.VariableNames;
if sum(matches(headers,'delta'))==0

    Ages = {'PMP01' 212; 'PMP02' 211; 'PMP03' 208; 'PMP04' 171; 'PMP06' 184; ...
        'PMP07' 180; 'PMP08' 183; 'PMP09' 199; 'VMP02' 122; 'VMP03' 131; ...
        'VMP04' 136; 'VMP05' 135; 'VMP06' 190; 'VMP08' 177};
    for irow = 1:size(T,1)
        thissub = matches(Ages(:,1),T.Animal(irow));
        T.Age(irow) = Ages{thissub,2};
    end

elseif sum(matches(headers,'delta'))==1 %FFT Data

    Ages = {'PM1' 212; 'PM2' 211; 'PM3' 208; 'PM4' 171; 'PM5' 184; ...
        'PM6' 180; 'PM7' 183; 'PM8' 199; 'VM1' 122; 'VM2' 131; ...
        'VM3' 136; 'VM4' 135; 'VM5' 190; 'VM6' 177};
    for irow = 1:size(T,1)
        thissub = matches(Ages(:,1),T.Subject(irow));
        T.Age(irow) = Ages{thissub,2};
    end

end