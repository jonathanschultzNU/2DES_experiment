function lstruct = timeshift_v1(scans,lstruct)


spectra1D = zeros(numel(lstruct{1,1}.w3_cut),numel(lstruct{1,1}.t2),numel(scans));
for n = 1:numel(scans)
    for i = 1:length(lstruct{1,1}.t2)
        spectra1D(:,i,n)=mean(real(lstruct{1,n}.data_w1w3Acut(:,:,i)),2);
    end
end
w3maxind = findind(min(spectra1D(:,end,1)),spectra1D(end,:,1));

% Plot signals for each scan around time zero

figure('DefaultAxesFontSize',14)
subplot(2,1,1)
for n = 1:length(scans)
    temp(:,1) = spectra1D(w3maxind,:,n);
    plot(lstruct{1,n}.t2,temp,'Linewidth',1)
    xlim([-300 300])
    hold on
end
hold off
title('without t2 correction')
xline(0);

 Legend=cell(length(scans),1);
 for n=1:length(scans)
   Legend{n}=strcat('scan ', num2str(scans(n)));
 end
 legend(Legend)

 % Shift scans to time zero and re-plot

subplot(2,1,2)
for n = 1:length(scans)
    temp(:,1) = spectra1D(w3maxind,:,n);
    plot(lstruct{1,n}.t2+lstruct{1,length(scans)+1}.shiftvals(n),temp,'Linewidth',1)
    hold on
end
xlim([-300 300])
title('with t2 correction')
xline(0);
hold off

%  Legend=cell(length(scans),1);
%  for i=n:length(scans)
%    Legend{n}=strcat('scan ', num2str(scans(n)));
%  end
 legend(Legend)
 
for n = 1:length(scans)
    lstruct{1,n}.t2s = lstruct{1,n}.t2+lstruct{1,length(scans)+1}.shiftvals(n);
end

end