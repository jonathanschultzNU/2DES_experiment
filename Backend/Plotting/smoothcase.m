function lstruct = smoothcase(scans, smoothopt, lstruct, opts)

order = opts.order;
method = opts.method;
framelen = opts.framelen;
sigs = opts.sigs;

for i = 1:length(scans)
    
    switch smoothopt
        case "true"
        
        switch sigs
            case 'absorptive'
                lstruct{1,i}.datw1w3Asm = smooth_2D_v3(lstruct{1,i}.data_w1w3Acut,lstruct{1,i}.nfiles,order,method,framelen);
            case 'absorptive, rephasing, non-rephasing'
                lstruct{1,i}.datw1w3Asm = smooth_2D_v3(lstruct{1,i}.data_w1w3Acut,lstruct{1,i}.nfiles,order,method,framelen);
                lstruct{1,i}.datw1w3Rsm = smooth_2D_v3(lstruct{1,i}.data_w1w3Rcut,lstruct{1,i}.nfiles,order,method,framelen);
                lstruct{1,i}.datw1w3NRsm = smooth_2D_v3(lstruct{1,i}.data_w1w3NRcut,lstruct{1,i}.nfiles,order,method,framelen);
            otherwise
                disp('Invalid case expression')
        end
    
        case "false"
            switch sigs
            case 'absorptive'
                lstruct{1,i}.datw1w3Asm = lstruct{1,i}.data_w1w3Acut;
            case 'absorptive, rephasing, non-rephasing'
                lstruct{1,i}.datw1w3Asm = lstruct{1,i}.data_w1w3Acut;
                lstruct{1,i}.datw1w3Rsm = lstruct{1,i}.data_w1w3Rcut;
                lstruct{1,i}.datw1w3NRsm = lstruct{1,i}.data_w1w3NRcut;
            otherwise
                disp('Invalid case expression')
            end
    end
end
end