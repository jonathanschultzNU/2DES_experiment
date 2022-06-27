function [lstruct, i] = trim2d(scans, lstruct, sigs, w1lims, w3lims, opts)

switch opts.prevload
    case "false"
        
    for i = 1:length(scans)
        indw1 = lstruct{1,i}.w1>w1lims(1) & lstruct{1,i}.w1<w1lims(2);  % wide view
        indw3 = lstruct{1,i}.w3>w3lims(1) & lstruct{1,i}.w3<w3lims(2);

        lstruct{1,i}.w1_cut = lstruct{1,i}.w1(indw1);
        lstruct{1,i}.w3_cut = lstruct{1,i}.w3(indw3);

        switch sigs
            case 'absorptive'
                lstruct{1,i}.data_w1w3Acut = lstruct{1,i}.datw1w3A(indw3,indw1,:);
            case 'absorptive, rephasing, non-rephasing'
                lstruct{1,i}.data_w1w3Acut = lstruct{1,i}.datw1w3A(indw3,indw1,:);
                lstruct{1,i}.data_w1w3Rcut = lstruct{1,i}.datw1w3R(indw3,indw1,:);
                lstruct{1,i}.data_w1w3NRcut = lstruct{1,i}.datw1w3NR(indw3,indw1,:);
            otherwise
                disp('Invalid case expression')
        end

    end
    
    case "true"
        
    for i = 1:length(scans)
        indw1 = lstruct{1,i}.w1_cut>w1lims(1) & lstruct{1,i}.w1_cut<w1lims(2);  % wide view
        indw3 = lstruct{1,i}.w3_cut>w3lims(1) & lstruct{1,i}.w3_cut<w3lims(2);

        lstruct{1,i}.w1_cut = lstruct{1,i}.w1_cut(indw1);
        lstruct{1,i}.w3_cut = lstruct{1,i}.w3_cut(indw3);

        switch sigs
            case 'absorptive'
                lstruct{1,i}.data_w1w3Acut = lstruct{1,i}.data_w1w3Acut(indw3,indw1,:);
            case 'absorptive, rephasing, non-rephasing'
                lstruct{1,i}.data_w1w3Acut = lstruct{1,i}.data_w1w3Acut(indw3,indw1,:);
                lstruct{1,i}.data_w1w3Rcut = lstruct{1,i}.data_w1w3Rcut(indw3,indw1,:);
                lstruct{1,i}.data_w1w3NRcut = lstruct{1,i}.data_w1w3NRcut(indw3,indw1,:);
            otherwise
                disp('Invalid case expression')
        end

    end

end