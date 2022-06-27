function lstruct = norm2DES(lstruct,scans,sigs)

for i = 1:length(scans)
    switch sigs
        case 'absorptive'
            
            rangew3 = lstruct{1,i}.w3_cut < 20000 & lstruct{1,i}.w3_cut > 12000;
            rangew1 = lstruct{1,i}.w1_cut < 18000 & lstruct{1,i}.w1_cut > 14000;
            ranget2 = lstruct{1,i}.t2s > 10;
            maxdata = lstruct{1,i}.datw1w3Asm(rangew3,rangew1,ranget2);
            maxval= max(max(max(abs(maxdata))));
%               maxval= max(max(max(abs(lstruct{1,i}.datw1w3Asm))));

            lstruct{1,i}.dataw1w3A_norm = zeros(size(lstruct{1,i}.datw1w3Asm));
            for k=1:lstruct{1,i}.nfiles
%                 lstruct{1,i}.dataw1w3A_norm(:,:,k) = normdim((lstruct{1,i}.datw1w3Asm(:,:,k)));
                  lstruct{1,i}.dataw1w3A_norm(:,:,k) = lstruct{1,i}.datw1w3Asm(:,:,k)./maxval;
            end  
       
        case 'absorptive, rephasing, non-rephasing'
            
            lstruct{1,i}.dataw1w3A_norm = zeros(size(lstruct{1,i}.datw1w3Asm));
            lstruct{1,i}.dataw1w3R_norm = zeros(size(lstruct{1,i}.datw1w3Rsm));
            lstruct{1,i}.dataw1w3NR_norm = zeros(size(lstruct{1,i}.datw1w3NRsm));
            
            for k=1:lstruct{1,i}.nfiles
                lstruct{1,i}.dataw1w3A_norm(:,:,k) = normdim((lstruct{1,i}.datw1w3Asm(:,:,k)));
                lstruct{1,i}.dataw1w3R_norm(:,:,k) = normdim((lstruct{1,i}.datw1w3Rsm(:,:,k)));
                lstruct{1,i}.dataw1w3NR_norm(:,:,k) = normdim((lstruct{1,i}.datw1w3NRsm(:,:,k)));
            end  
        
        otherwise
            disp('Invalid case expression')
    end

end

