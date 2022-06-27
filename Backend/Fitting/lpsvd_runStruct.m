function out = lpsvd_runStruct(lstruct,QBstruct,opts,lpsvd)

indw1 = QBstruct.w1slim >= lpsvd.w1cent-0.5*lpsvd.boxdim & QBstruct.w1slim <= lpsvd.w1cent+0.5*lpsvd.boxdim;
indw3 = QBstruct.w3slim >= lpsvd.w3cent-0.5*lpsvd.boxdim & QBstruct.w3slim <= lpsvd.w3cent+0.5*lpsvd.boxdim;

switch opts.sigplot
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

data = QBstruct.(isofield)(indw3,indw1,:);
time = lstruct.t2qb;
datavec = zeros(size(time));

for i = 1:length(time)
    tempmat = data(:,:,i);
    datavec(i) = mean(mean(tempmat)); 
end

[lpsvd_temp, params] = lpsvd_range(datavec,time,'tls','aic'); 

t2n = (time(1):mean(diff(time)):mean(diff(time))*(lpsvd.pad-1)+time(1));
t2n = t2n';
lpsvd_vecpad = zeros(lpsvd.pad,1);
lpsvd_vecpad(1:length(time)) = lpsvd_temp;

for i=length(lpsvd_temp)+1:length(t2n)
    lpsvd_vecpad(i,1) = params.model(t2n(i));
end

c = 2.9979 * 10^-5;      % [cm/fs]       
dw2 = 1 / (c*mean(diff(time))*lpsvd.pad);                        %defining the frequency step [cm-1]
w2 = ((-lpsvd.pad*dw2)/2:dw2:((lpsvd.pad*dw2)/2-dw2));      %frequency axis     [cm-1]                       

lpsvd_freq = fftshift(fft(lpsvd_vecpad));
freqvec = params.frequency.*3.33565*10^4; 
ampvec = params.amplitude; 
dampvec = 1./params.damping;

figure
subplot(1,2,1)
scatter(time,real(datavec),5,'k','filled')
hold on
plot(time,real(lpsvd_temp),'r','LineWidth',2)
box on
xlabel('t2 (fs)')
ylabel('signal amplitude (a.u.)')
xlim([min(time) max(time)])
set(gca, 'FontSize', 18);
hold off

dataFFT = real_FFT_v1(permute(datavec,[1,3,2]),lstruct.t2qb,1,1,lpsvd.pad,lstruct.nzero);
dataFFT = permute(dataFFT,[3,1,2]);

subplot(1,2,2)
plot(w2,abs(lpsvd_freq),'r','LineWidth',2)
hold on
plot(w2,abs(dataFFT),'k','LineWidth',2)
xlabel('\omega/2\pic (cm^-^1)'); ylabel('FFT amplitude (a.u.)')
xlim([-1800 1800])
set(gca, 'FontSize', 18);
hold off

out.datatime = datavec;
out.datafreq = abs(permute(dataFFT,[3,1,2]));
out.dataw2 = QBstruct.w2;
out.time = real(lpsvd_temp);
out.freq = abs(lpsvd_freq);
out.w2 = w2';
out.amplist = ampvec;
out.freqlist = freqvec;
out.dephaselist = dampvec;
out.lpsvdparam = params;

end
