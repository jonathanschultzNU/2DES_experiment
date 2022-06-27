function QBstruct = smoothfreqcase_v2(scans, order, method, opts, QBstruct, framelen, sigs)
for i = 1:length(scans)
    
    if opts.smoothopt == 1
        
        switch sigs
        case 'absorptive'
            QBstruct{1,i}.dataw1w2w3Asm = smooth_2D_v4(QBstruct{1,i}.dataw1w2w3Ac,QBstruct{1,i}.npad,order,method,framelen);
        case 'absorptive, rephasing, non-rephasing'
            QBstruct{1,i}.dataw1w2w3Asm = smooth_2D_v4(QBstruct{1,i}.dataw1w2w3Ac,QBstruct{1,i}.npad,order,method,framelen);
            QBstruct{1,i}.dataw1w2w3Rtotsm = smooth_2D_v4(QBstruct{1,i}.dataw1w2w3Rtotc,QBstruct{1,i}.npad,order,method,framelen);
            QBstruct{1,i}.dataw1w2w3NRtotsm = smooth_2D_v4(QBstruct{1,i}.dataw1w2w3NRtotc,QBstruct{1,i}.npad,order,method,framelen);
            otherwise
            disp('Invalid case expression')
        end
    
    elseif opts.smoothopt == 0
        switch sigs
        case 'absorptive'
            QBstruct{1,i}.dataw1w2w3Asm = QBstruct{1,i}.dataw1w2w3A;
        case 'absorptive, rephasing, non-rephasing'
            QBstruct{1,i}.dataw1w2w3Asm = QBstruct{1,i}.dataw1w2w3A;
            QBstruct{1,i}.dataw1w2w3Rtotsm = QBstruct{1,i}.dataw1w2w3Rtot;
            QBstruct{1,i}.dataw1w2w3NRtotsm = QBstruct{1,i}.dataw1w2w3NRtot;
            otherwise
            disp('Invalid case expression')
        end
    end
end
end