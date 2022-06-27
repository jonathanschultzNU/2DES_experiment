function MDplot(xdata, ydata, zdata,t2val)
%CREATEFIGURE(xdata1, ydata1, zdata1, XData2)
%  XDATA1:  contour x
%  YDATA1:  contour y
%  ZDATA1:  contour z

% xdata = (10^7)./xdata;
% ydata = (10^7)./ydata;
xdata = xdata./1000;
ydata = ydata./1000;


% cmap = load('C:\Users\schul\Documents\MATLAB\Graduate\Wasielewski Group\ColorSchemes\cmap_whitemiddle_2.txt');
cmap = cmap2d(20);
maxval = max(max(abs(zdata)));
llist = -1:0.05:1;
% llist = -maxval:(maxval/20):maxval;
% Create contour
contourf(xdata,ydata,zdata,'LineWidth',0.25,'LevelList',llist);
colormap(cmap)
hold on

% Create line
line('XData',[min(ydata) max(ydata)],'YData',[min(ydata) max(ydata)],'Linewidth',1.5);

% Create ylabel
ylabel('\omega_{3} (10^{3} cm^{-1})');
% ylabel('\lambda_{3} (nm)');

% Create xlabel
xlabel('\omega_{1} (10^{3} cm^{-1})');
% xlabel('\lambda_{1} (nm)');

% Create title
title(strcat('t2 = ', num2str(round(t2val)), ' fs'));

box on
set(gca,'BoxStyle','full','CLim',[llist(1)./2 llist(end)./2],'DataAspectRatio',[1 1 1],...
    'FontSize',16,'Layer','top');

xlim([min(xdata) max(xdata)])
ylim([min(ydata) max(ydata)])

