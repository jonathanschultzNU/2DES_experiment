function lstruct = cuttimes(scans, lstruct, sigs, t2min, t2max)

for i = 1:length(scans)

    indt2 = lstruct{1,i}.t2s>t2min & lstruct{1,i}.t2s<t2max;
    lstruct{1,i}.t2qb = lstruct{1,i}.t2s(indt2);          %cut timepoints
    lstruct{1,i}.nzero = length(0:mean(diff(lstruct{1,i}.t2s)):min(lstruct{1,i}.t2qb))-1;
    
    switch sigs
        case 'absorptive'
            
            lstruct{1,i}.dataw1w3Aqb = real(lstruct{1,i}.data_w1w3Acut(:,:,indt2));
            
        case 'absorptive, rephasing, non-rephasing'
            
            lstruct{1,i}.dataw1w3Aqb = real(lstruct{1,i}.data_w1w3Acut(:,:,indt2));
            lstruct{1,i}.dataw1w3Rqbr = real(lstruct{1,i}.data_w1w3Rcut(:,:,indt2));
            lstruct{1,i}.dataw1w3Rqbi = imag(lstruct{1,i}.data_w1w3Rcut(:,:,indt2));
            lstruct{1,i}.dataw1w3NRqbr = real(lstruct{1,i}.data_w1w3NRcut(:,:,indt2));
            lstruct{1,i}.dataw1w3NRqbi = imag(lstruct{1,i}.data_w1w3NRcut(:,:,indt2));
            
        otherwise
            
            disp('Invalid signal specification')
    end

end

end