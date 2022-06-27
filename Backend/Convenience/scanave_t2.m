function avespec = scanave_t2(timeselect, scans, lstruct)

avespec.datw1t2w3 = zeros(length(lstruct{1,1}.w3_cut),length(lstruct{1,1}.w1_cut),length(timeselect));

for i = 1:length(timeselect)
    tempave = zeros(length(lstruct{1,1}.w3_cut),length(lstruct{1,1}.w1_cut),length(scans));
    
    for j = 1:length(scans)
        tempave(:,:,j) = lstruct{1,j}.dataw1w3_plot(:,:,i);
    end
    
    avespec.datw1t2w3(:,:,i) = mean(tempave,3);
end
end