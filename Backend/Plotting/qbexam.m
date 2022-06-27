function qbexam(lstruct,QBstruct,timeselect,signal)
%CREATEFIGURE(xdata1, ydata1, zdata1, XData2)
%  XDATA1:  contour x
%  YDATA1:  contour y
%  ZDATA1:  contour z

switch signal
    case 'absorptive'
        t2field = 'dataw1w3Aqbslim';
    case 'rephasing'
        t2field = 'dataw1w3Rqbrslim';
    case 'non-rephasing'
        t2field = 'dataw1w3NRqbrslim';
    otherwise
end

t2data = lstruct.(t2field);

% Create contour
contourf(lstruct.w1slim,lstruct.w3slim,normdim(t2data(:,:,timeselect)),'LineWidth',0.25,'LevelStep',0.1,'ButtonDownFcn',{@ButtonDownFcn2DES_live, lstruct, QBstruct,signal});
colormap(cmap2d(10))
hold on

% Create line
line(min(lstruct.w1slim),max(lstruct.w1slim),'LineWidth',1.5);

% Create ylabel
ylabel('\omega_{3} (cm^{-1})');

% Create xlabel
xlabel('\omega_{1} (cm^{-1})');

% Create title
title(['t2 = ' num2str(lstruct.t2qb(timeselect)) ' fs']);

box on
% set(gca,'BoxStyle','full','CLim',[-1 1],'DataAspectRatio',[1 1 1],...
%     'FontSize',12,'Layer','top');
set(gca,'BoxStyle','full','CLim',[-1 1],'FontSize',18,'Layer','top');

xlim([min(lstruct.w1slim) max(lstruct.w1slim)])
ylim([min(lstruct.w3slim) max(lstruct.w3slim)])

end