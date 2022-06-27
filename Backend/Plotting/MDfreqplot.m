function MDfreqplot(xdata, ydata, zdata,w2val,cmap)
%CREATEFIGURE(xdata1, ydata1, zdata1, XData2)
%  XDATA1:  contour x
%  YDATA1:  contour y
%  ZDATA1:  contour z

% Create contour
contourf(xdata,ydata,zdata,'LineWidth',0.25,'LevelStep',0.1); %'edgecolor','none');
colormap(cmap)
hold on

% Create lines
line('XData',[min(ydata) max(ydata)],'YData',[min(ydata) max(ydata)],'Linewidth',1.5);
hold on
yplus = xdata+w2val; yminus = xdata-w2val;
yplus2 = xdata+2.*w2val; yminus2 = xdata-2.*w2val;

plot(xdata,yplus,'--k','LineWidth',1)
hold on
plot(xdata,yminus,'--k','LineWidth',1)
hold on
plot(xdata,yplus2,'--k','LineWidth',1)
hold on
plot(xdata,yminus2,'--k','LineWidth',1)

% Define limits
xlim([min(xdata) max(xdata)])
ylim([min(ydata) max(ydata)])


% Create ylabel
ylabel('\omega_{3} (10^{3} cm^{-1})');

% Create xlabel
xlabel('\omega_{1} (10^{3} cm^{-1})');

% Create title
title(strcat('w2 = ', num2str(w2val), ' cm-1'));

box on
set(gca,'BoxStyle','full','CLim',[-1 1],'DataAspectRatio',[1 1 1],...
    'FontSize',18,'Layer','top');
