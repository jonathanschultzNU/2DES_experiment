function out = ButtonDownFcn2DES_live(object, eventdata, lstruct, QBstruct,signal)

c_point = get (gca, 'CurrentPoint');

w3 = lstruct.w3slim;
w1 = lstruct.w1slim;

rowval = c_point(1,2);                       %value of w3 to find
colval = c_point(1,1);                       %value of w1 to find
idxrow = findind(w3,rowval);
idxcol = findind(w1,colval);
 
switch signal
    case 'absorptive'
        t2field = 'dataw1w3Aqbslim';
        w2field = 'dataw1w2w3A';
        fitsfield = 'Afits';
        isofield = 'Aiso';
    case 'rephasing'
        t2field = 'dataw1w3Rqbrslim';
        w2field = 'dataw1w2w3Rtot';
        fitsfield = 'Rrfits';
        isofield = 't2Rtotiso';
    case 'non-rephasing'
        t2field = 'dataw1w3NRqbrslim';
        w2field = 'dataw1w2w3NRtot';
        fitsfield = 'NRrfits';
        isofield = 't2NRtotiso';
    otherwise
end

pop = lstruct.(t2field);
pwr = abs(QBstruct.(w2field));
fits = QBstruct.(fitsfield);
isos = QBstruct.(isofield);

pop_check(1,:) = pop(idxrow,idxcol,:);
fit_check(1,:) = fits(idxrow,idxcol,:);
residual_check(1,:) = isos(idxrow,idxcol,:);
pwr_check(1,:) = pwr(idxrow,idxcol,:);
w_beat = QBstruct.w2;
t2 = lstruct.t2qb;

subplot(2,3,2)
scatter(t2,pop_check,3,'filled','k')
hold on
plot(t2,fit_check,'r','LineWidth',1.5)
% title(c_point(1,1))
title('Data and fit')
box on
xlabel('t{2} (fs)');
set(gca,'FontSize',18)
hold off

lpsvd = lpsvdrun(t2,residual_check,2^10);

subplot(2,3,3)
scatter(t2,residual_check,3,'filled','k')
hold on
plot(t2,lpsvd.time,'r','Linewidth',1)
hold off
% title(c_point(1,2))
title('Residual + lpsvd')
yline(0)
box on
xlabel('t_{2} (fs)');
set(gca,'FontSize',18)

subplot(2,3,4)
plot(w_beat,abs(pwr_check),'k','Linewidth',2)
% title(c_point(1,2))
title('FFT')
xlim([-1700 1700])
xlabel('\omega_{beat} (cm^{-1})');
box on
set(gca, 'FontSize', 18);

fwidth = 300;
% QBstruct.indw1slim = w1>=colval-fwidth & w1<=colval+fwidth;
% QBstruct.indw3slim = w3>=rowval-fwidth & w3<=rowval+fwidth;
frange.w1cent = colval;
frange.w3cent = rowval;
frange.boxdim = fwidth;
redo = 0;
fstruct = frobnormv2l(lstruct,QBstruct,frange, 25,'freq',redo,0,signal);

subplot(2,3,5)
plot(fstruct.w2,fstruct.frobnorm,'b','Linewidth',2)
title('Frob. Norm')
xlabel('\omega/2\pic (cm^-^1)')
xlim([0 2300])
set(gca, 'FontSize', 18);

subplot(2,3,6)
plot(w_beat,abs(pwr_check),'k','Linewidth',2)
hold on
plot(lpsvd.w2,lpsvd.freq,'r','Linewidth',1)
title('FFT + lpsvd')
xlim([0 2300])
xlabel('\omega_{beat} (cm^{-1})');
set(gca, 'FontSize', 18);
hold off

out{1,1}.pumpval = colval;
out{1,1}.probeval = rowval;
out{1,1}.timedata = pop_check';
out{1,1}.timefit = fit_check';
out{1,1}.timeiso = residual_check';
out{1,1}.FFT = abs(pwr_check)';
out{1,1}.w2 = w_beat';
out{1,1}.t2 = t2';

out{1,2} = fstruct;
out{1,3} = lpsvd;

save('temp.mat', 'out');

end





        