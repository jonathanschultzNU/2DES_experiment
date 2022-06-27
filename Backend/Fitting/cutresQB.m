function lstruct = cutresQB(scans, lstruct, sigs, w1space, w3space)
for i = 1:length(scans)
    
    lstruct{1,i}.w1space = w1space;
    lstruct{1,i}.w3space = w3space;
    
    switch sigs
        
        case 'absorptive'
            lstruct{1,i}.dataw1w3Aqbslim = zeros(size(lstruct{1,i}.dataw1w3Aqb(1:lstruct{1,i}.w3space:end,1:lstruct{1,i}.w1space:end,:)));     %initialize slimmed matrix
            
            for k = 1:length(lstruct{1,i}.t2qb)
                lstruct{1,i}.dataw1w3Aqbslim(:,:,k) = real(lstruct{1,i}.dataw1w3Aqb(1:lstruct{1,i}.w3space:end,1:lstruct{1,i}.w1space:end,k));
            end
        
        case 'absorptive, rephasing, non-rephasing'
            lstruct{1,i}.dataw1w3Aqbslim = zeros(size(lstruct{1,i}.dataw1w3Aqb(1:lstruct{1,i}.w3space:end,1:lstruct{1,i}.w1space:end,:)));     %initialize slimmed matrix
            lstruct{1,i}.dataw1w3Rqbrslim = zeros(size(lstruct{1,i}.dataw1w3Rqbr(1:lstruct{1,i}.w3space:end,1:lstruct{1,i}.w1space:end,:)));     %initialize slimmed matrix
            lstruct{1,i}.dataw1w3Rqbislim = zeros(size(lstruct{1,i}.dataw1w3Rqbi(1:lstruct{1,i}.w3space:end,1:lstruct{1,i}.w1space:end,:)));     %initialize slimmed matrix
            lstruct{1,i}.dataw1w3NRqbrslim = zeros(size(lstruct{1,i}.dataw1w3NRqbr(1:lstruct{1,i}.w3space:end,1:lstruct{1,i}.w1space:end,:)));     %initialize slimmed matrix
            lstruct{1,i}.dataw1w3NRqbislim = zeros(size(lstruct{1,i}.dataw1w3NRqbi(1:lstruct{1,i}.w3space:end,1:lstruct{1,i}.w1space:end,:)));     %initialize slimmed matrix

            
            for k = 1:length(lstruct{1,i}.t2qb)
                lstruct{1,i}.dataw1w3Aqbslim(:,:,k) = lstruct{1,i}.dataw1w3Aqb(1:lstruct{1,i}.w3space:end,1:lstruct{1,i}.w1space:end,k);
                lstruct{1,i}.dataw1w3Rqbrslim(:,:,k) = lstruct{1,i}.dataw1w3Rqbr(1:lstruct{1,i}.w3space:end,1:lstruct{1,i}.w1space:end,k);
                lstruct{1,i}.dataw1w3Rqbislim(:,:,k) = lstruct{1,i}.dataw1w3Rqbi(1:lstruct{1,i}.w3space:end,1:lstruct{1,i}.w1space:end,k);
                lstruct{1,i}.dataw1w3NRqbrslim(:,:,k) = lstruct{1,i}.dataw1w3NRqbr(1:lstruct{1,i}.w3space:end,1:lstruct{1,i}.w1space:end,k);
                lstruct{1,i}.dataw1w3NRqbislim(:,:,k) = lstruct{1,i}.dataw1w3NRqbi(1:lstruct{1,i}.w3space:end,1:lstruct{1,i}.w1space:end,k);
            end
            
    end
       
    
    lstruct{1,i}.w1slim = lstruct{1,i}.w1_cut(1:lstruct{1,i}.w1space:end);       %define slimmed w1 axis
    lstruct{1,i}.w3slim = lstruct{1,i}.w3_cut(1:lstruct{1,i}.w3space:end);       %define slimmed w3 axis

end
end