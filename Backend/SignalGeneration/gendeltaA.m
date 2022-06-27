function lstruct = gendeltaA(scans, saveframedata, lstruct, scheme, sigs)

for i = 1:length(scans)
    switch sigs
        case 'absorptive'
            lstruct{1,i}.datw1w3A = zeros(length(lstruct{1,i}.w3),length(lstruct{1,i}.w1),lstruct{1,i}.nfiles);
        case 'absorptive, rephasing, non-rephasing'
            lstruct{1,i}.datw1w3A = zeros(length(lstruct{1,i}.w3),length(lstruct{1,i}.w1),lstruct{1,i}.nfiles);
            lstruct{1,i}.datw1w3R = zeros(length(lstruct{1,i}.w3),length(lstruct{1,i}.w1),lstruct{1,i}.nfiles);
            lstruct{1,i}.datw1w3NR = zeros(length(lstruct{1,i}.w3),length(lstruct{1,i}.w1),lstruct{1,i}.nfiles);
        otherwise
            disp('Invalid case expression')
    end

    for k = 1:lstruct{1,i}.nfiles
        data_t = lstruct{1,i}.datat(:,:,k);
        if strcmp('ON',saveframedata) == 1
            if strcmp('ABS',scheme) == 1
                dataproc = abs4framev1(data_t,lstruct{1,i}.t1,lstruct{1,i}.t2,lstruct{1,i}.w1,lstruct{1,i}.w3);
            elseif strcmp('RNR',scheme) == 1
                dataproc =rnr4framev4(data_t,lstruct{1,i}.t1,lstruct{1,i}.t2,lstruct{1,i}.w1,lstruct{1,i}.w3); %rnr4framev3
            end
        elseif strcmp('OFF',saveframedata) == 1
            dataproc = absprocv1(data_t,lstruct{1,i}.t1,lstruct{1,i}.t2,lstruct{1,i}.w1,lstruct{1,i}.w3);
        end
        
        switch sigs
            case 'absorptive'
                lstruct{1,i}.datw1w3A(:,:,k) = -dataproc.absorptive;  %phase flips in relation to abs scheme - abs scheme is rotated compared to literature
            case 'absorptive, rephasing, non-rephasing'
                lstruct{1,i}.datw1w3A(:,:,k) = dataproc.absorptive;
                lstruct{1,i}.datw1w3R(:,:,k) = dataproc.rephasing;
                lstruct{1,i}.datw1w3NR(:,:,k) = dataproc.nonrephasing;
            otherwise
                disp('Invalid case expression')
        end
                
    end

clear data_t; clear dataproc;
disp(['Scan' num2str(scans(i)) 'processed']);
end
end