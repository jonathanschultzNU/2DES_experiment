function lstruct = plot2Dt(timeselect, scans, lstruct, numrow, signal)


for i = 1:length(scans)
    
    if isfield(lstruct{1,i},'dataw1w3_plot') == 1
        lstruct{1,i} = rmfield(lstruct{1,i},'dataw1w3_plot');
    end
    lstruct{1,i}.timeinds = zeros(size(timeselect));
    
    for j = 1:length(timeselect)
        lstruct{1,i}.timeinds(j) = findind(lstruct{1,i}.t2s,timeselect(j));
         switch signal
            case 'absorptive'
%                 lstruct{1,i}.dataw1w3_plot(:,:,j) = (lstruct{1,i}.datw1w3Asm(:,:,lstruct{1,i}.timeinds(j)));
                lstruct{1,i}.dataw1w3_plot(:,:,j) = (lstruct{1,i}.dataw1w3A_norm(:,:,lstruct{1,i}.timeinds(j)));
            case 'rephasing'
                lstruct{1,i}.dataw1w3_plot(:,:,j) = (lstruct{1,i}.dataw1w3R_norm(:,:,lstruct{1,i}.timeinds(j)));
            case 'non-rephasing'
                lstruct{1,i}.dataw1w3_plot(:,:,j) = (lstruct{1,i}.dataw1w3NR_norm(:,:,lstruct{1,i}.timeinds(j)));
            otherwise
                disp('Invalid case expression')
         end
    end
    
    disp(['Scan' num2str(scans(i))])
    
    fig = figure;
    for j=1:length(timeselect)
        subplot1 = subplot(numrow,length(timeselect)./numrow,j,'Parent',fig);
        hold(subplot1,'on');
        MDplot_v2(lstruct{1,i}.w1_cut,lstruct{1,i}.w3_cut,real(lstruct{1,i}.dataw1w3_plot(:,:,j)),round(lstruct{1,i}.t2s(lstruct{1,i}.timeinds(j)),1),length(timeselect),j,fig)
    end
    hold off
end
end