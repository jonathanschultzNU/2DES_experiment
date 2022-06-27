function QBstruct = norm2DESfreq(QBstruct,scans,sigs,range)

for i = 1:length(scans)
    switch sigs
        case 'absorptive'
            
            QBstruct{1,i}.dataw1w2w3Anorm = zeros(size(QBstruct{1,i}.dataw1w2w3Asm));
            for k=1:QBstruct{1,i}.npad
                QBstruct{1,i}.dataw1w2w3Anorm(:,:,k) = normdim((QBstruct{1,i}.dataw1w2w3Asm(:,:,k)));
            end  
       
        case 'absorptive, rephasing, non-rephasing'
            
            QBstruct{1,i}.dataw1w2w3Anorm = zeros(size(QBstruct{1,i}.dataw1w2w3Asm));
            QBstruct{1,i}.dataw1w2w3Rtotnorm= zeros(size(QBstruct{1,i}.dataw1w2w3Rtotsm));
            QBstruct{1,i}.dataw1w2w3NRtotnorm = zeros(size(QBstruct{1,i}.dataw1w2w3NRtotsm));
            
%             maxval = max(max(max(abs(QBstruct{1,i}.dataw1w2w3Asm(range,:,:)))));

            for k=1:QBstruct{1,i}.npad
                maxvalA = max(max(abs(QBstruct{1,i}.dataw1w2w3Asm(range,:,k))));
                maxvalR = max(max(abs(QBstruct{1,i}.dataw1w2w3Rtotsm(range,:,k))));
                maxvalNR = max(max(abs(QBstruct{1,i}.dataw1w2w3NRtotsm(range,:,k))));
                QBstruct{1,i}.dataw1w2w3Anorm(:,:,k) = QBstruct{1,i}.dataw1w2w3Asm(:,:,k)./maxvalA;
                QBstruct{1,i}.dataw1w2w3Rtotnorm(:,:,k) = QBstruct{1,i}.dataw1w2w3Rtotsm(:,:,k)./maxvalR;
                QBstruct{1,i}.dataw1w2w3NRtotnorm(:,:,k) = QBstruct{1,i}.dataw1w2w3NRtotsm(:,:,k)./maxvalNR;
            end  
        
        otherwise
            disp('Invalid case expression')
    end

end

