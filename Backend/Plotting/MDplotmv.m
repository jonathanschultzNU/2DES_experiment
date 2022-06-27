function MDplotmv(xdata, ydata, zdata,t2val,lstruct,QBstruct)
%CREATEFIGURE(xdata1, ydata1, zdata1, XData2)
%  XDATA1:  contour x
%  YDATA1:  contour y
%  ZDATA1:  contour z

% Create contour
contourf(xdata,ydata,zdata,'LineWidth',0.25,'LevelStep',0.1,'ButtonDownFcn',{@ButtonDownFcn2DES, lstruct, QBstruct});
colormap(cmap2d(10))
hold on

% Create line
line(min(xdata),max(xdata),'LineWidth',1.5);

% Create ylabel
ylabel('\omega_{3} (cm^{-1})');

% Create xlabel
xlabel('\omega_{1} (cm^{-1})');

% Create title
title(t2val);

box on
set(gca,'BoxStyle','full','CLim',[-1 1],'DataAspectRatio',[1 1 1],...
    'FontSize',18,'Layer','top');


xlim([min(xdata) max(xdata)])
ylim([min(ydata) max(ydata)])

