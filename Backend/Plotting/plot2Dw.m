function [QBstruct, avespec] = plot2Dw(scans, lstruct, QBstruct, opt)

freqres = mean(diff(QBstruct{1,1}.w2));

w2r = round(QBstruct{1,1}.w2);
freqinds = zeros(size(opt.mapfreqs));
for i = 1:length(opt.mapfreqs)
    freqinds(i) = findind(w2r,opt.mapfreqs(i));
end

     switch opt.sigplot
        case 'absorptive'
            tagsig = 'A';
            normname2 = 'dataw1w2w3Asm';
            normname = 'dataw1w2w3Anorm';
%             lstruct{1,i}.dataw1w3_plot(:,:,j) = (lstruct{1,i}.dataw1w3A_norm(:,:,lstruct{1,i}.timeinds(j)));
        case 'rephasing'
            tagsig = 'R';
            normname2 = 'dataw1w2w3Rtotsm';
            normname = 'dataw1w2w3Rtotnorm';
%             lstruct{1,i}.dataw1w3_plot(:,:,j) = (lstruct{1,i}.dataw1w3R_norm(:,:,lstruct{1,i}.timeinds(j)));
        case 'non-rephasing'
            tagsig = 'NR';
            normname2 = 'dataw1w2w3NRtotsm';
            normname = 'dataw1w2w3NRtotnorm';
%             lstruct{1,i}.dataw1w3_plot(:,:,j) = (lstruct{1,i}.dataw1w3NR_norm(:,:,lstruct{1,i}.timeinds(j)));
         otherwise
            disp('Invalid case expression')
     end

fieldname = ['dataw1w2w3' tagsig 'beatmaps'];
    
for n = 1:length(scans)
    %calculate beatmaps averaged around a center frequency

    QBstruct{1,n}.(fieldname) = zeros(length(QBstruct{1,n}.w3slim), length(QBstruct{1,n}.w1slim), length(freqinds));
    for i=1:length(freqinds)
        freqplus = opt.mapfreqs(i)+freqres;
        freqminus = opt.mapfreqs(i)-freqres;
        indminus = findind(w2r,freqminus);
        indplus = findind(w2r,freqplus);
%         QBstruct{1,n}.(fieldname)(:,:,i) = mean(QBstruct{1,n}.(normname)(:,:,indminus:indplus),3);
        QBstruct{1,n}.(fieldname)(:,:,i) = mean(QBstruct{1,n}.(normname2)(:,:,indminus:indplus),3);
    end  
end

% switch opt.arcsin
%     case 1
%         for n = 1:length(scans)
%         %calculate beatmaps averaged around a center frequency
% 
%             for i=1:length(freqinds)
%                 QBstruct{1,n}.(fieldname)(:,:,i) = asinh(opt.arcsinval.*normdim(abs(QBstruct{1,n}.(fieldname)(:,:,i))));
%             end  
%         end
%     
%     case 0
% end

for n = 1:length(scans)
    disp(['Scan' num2str(scans(n))])
    fig = figure;
    for i=1:length(freqinds)
        subplot2 = subplot(1,length(freqinds),i,'Parent',fig);
        hold(subplot2,'on');
%         MDfreqplot(lstruct{1,n}.w1slim./1000, lstruct{1,n}.w3slim./1000, normdim(abs(QBstruct{1,n}.(fieldname)(:,:,i))),w2r(freqinds(i)),cmap2d(10))
        beatcontours_exp(fig,freqinds,i,0, QBstruct{1,n}.w1slim./1000, QBstruct{1,n}.w3slim./1000, abs(QBstruct{1,n}.(fieldname)(:,:,i)),w2r(freqinds(i)),cmap2d(10))
    end
    
end
% Calculate average beatmaps and plot
% fieldname2 = ['dataw1w2w3' tagsig2 'sm'];

avename = ['dataw1w2w3' tagsig 'AVGbeatmap'];
avespec.(avename) = zeros(length(QBstruct{1,1}.w3slim),length(QBstruct{1,1}.w1slim),length(opt.mapfreqs));
for i = 1:length(opt.mapfreqs)
    tempave = zeros(length(QBstruct{1,1}.w3slim),length(QBstruct{1,1}.w1slim),length(scans));
    for j = 1:length(scans)
        tempave(:,:,j) = abs(QBstruct{1,j}.(fieldname)(:,:,i));
    end
    avespec.(avename)(:,:,i) = mean(tempave,3);
%     avespec.(avename)(:,:,i) = normdim(avespec.(avename)(:,:,i));
end

disp('Average')
fig = figure;
for i=1:length(freqinds)
    subplot2 = subplot(1,length(freqinds),i,'Parent',fig);
    hold(subplot2,'on');
%     MDfreqplot(lstruct{1,n}.w1slim./1000, lstruct{1,n}.w3slim./1000, avespec.(avename)(:,:,i),w2r(freqinds(i)),cmap2d(10))
    beatcontours_exp(fig,freqinds,i,0, QBstruct{1,n}.w1slim./1000, QBstruct{1,n}.w3slim./1000, avespec.(avename)(:,:,i),w2r(freqinds(i)),cmap2d(10))
end
end