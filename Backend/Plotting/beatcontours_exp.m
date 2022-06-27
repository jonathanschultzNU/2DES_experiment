function beatcontours_exp(fig,freqinds,i,limcor, xdata, ydata, zdata,w2val,cmap)
%CREATEFIGURE(xdata1, ydata1, zdata1, XData2)
%  XDATA1:  contour x
%  YDATA1:  contour y
%  ZDATA1:  contour z

% w2val = w2val/1000;
maxval = max(max(zdata));
scaled = false;
% if abs(w2val) < 1000
%     zdata = zdata.*8;
%     scaled = true;
% end

% figure;
ax = axes();
hold(ax);
subplot2 = subplot(1,length(freqinds),i,'Parent',fig);
hold(subplot2,'on');
p = pcolor(xdata,ydata,zdata);
p.FaceAlpha = 0.8;
colormap(cmap)
shading interp
colorbar;
c = contour(xdata,ydata,zdata,'k','LineWidth',0.25,'LevelList',(0:0.2*maxval:maxval));
% Create contour
% contourf(xdata,ydata,zdata,10,'LineWidth',0.25); %'edgecolor','none');

hold on;

% Create lines
line('XData',[min(ydata) max(ydata)],'YData',[min(ydata) max(ydata)],'Linewidth',1.5);
hold on;
% yplus = xdata+w2val; yminus = xdata-w2val;
% yplus2 = xdata+2.*w2val; yminus2 = xdata-2.*w2val;
% 
% plot(xdata,yplus,'--k','LineWidth',1)
% hold on
% plot(xdata,yminus,'--k','LineWidth',1)
% hold on
% plot(xdata,yplus2,'--k','LineWidth',1)
% hold on
% plot(xdata,yminus2,'--k','LineWidth',1)

% plot(xdata,params.e1/1000,ydata,params.e1/1000,'--b','LineWidth',1)
% yline(params.e1/1000, 'k--', 'LineWidth', 1); hold on
% xline(params.e1/1000, 'k--', 'LineWidth', 1); hold on
% yline(params.sngap/1000, '--', 'Color', [1 0 0], 'LineWidth', 1); hold on
% xline(params.sngap/1000, '--', 'Color', [1 0 0], 'LineWidth', 1); hold on
% 
% for i = 1:length(params.wfreq)
%     j=i/2;
%     yline((params.e1+params.wfreq(i))/1000, ':', 'Color', [0 not(j) j], 'LineWidth', 1); hold on
%     xline((params.e1+params.wfreq(i))/1000, ':', 'Color', [0 not(j) j], 'LineWidth', 1); hold on
%     yline((params.e1+2*params.wfreq(i))/1000, ':', 'Color', [0 not(j) j], 'LineWidth', 1); hold on
%     xline((params.e1+2*params.wfreq(i))/1000, ':', 'Color', [0 not(j) j], 'LineWidth', 1); hold on
%     yline((params.e1-params.wfreq(i))/1000, ':', 'Color', [0 not(j) j], 'LineWidth', 1); hold on
% 
%     yline((params.sngap+params.wfreq(i))/1000, ':', 'Color', [j not(j) 0], 'LineWidth', 1); hold on
%     xline((params.sngap+params.wfreq(i))/1000, ':', 'Color', [j not(j) 0], 'LineWidth', 1); hold on
%     yline((params.sngap-params.wfreq(i))/1000, ':', 'Color', [j not(j) 0], 'LineWidth', 1); hold on
% end

% Define limits
xlim([min(xdata)+limcor max(xdata)-limcor])
ylim([min(ydata)+limcor max(ydata)-limcor])
% xlim([13.7 18])
% ylim([9.8 18])

% Create ylabel
ylabel('\omega_{3} (10^{3} cm^{-1})');

% Create xlabel
xlabel('\omega_{1} (10^{3} cm^{-1})');

% Create title
title(strcat('\omega_{2} =', num2str(w2val), ' cm^{-1}'));

box on
if scaled == 1
    annotation('textbox',[.49 .6 .1 .1],'String',"x8",'EdgeColor','none');
else
end
set(gca,'BoxStyle','full','CLim',0.5*[-maxval maxval],'DataAspectRatio',[1 1 1],...
    'FontSize',18,'Layer','top');
grid minor

