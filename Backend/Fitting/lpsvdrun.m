function out = lpsvdrun(time,datavec,pad)

[lpsvd_temp, params] = lpsvd_range(datavec,time,'tls','aic'); 

t2n = (time(1):mean(diff(time)):mean(diff(time))*(pad-1)+time(1));
t2n = t2n';
lpsvd_vecpad = zeros(pad,1);
lpsvd_vecpad(1:length(time)) = lpsvd_temp;

for i=length(lpsvd_temp)+1:length(t2n)
    lpsvd_vecpad(i,1) = params.model(t2n(i));
end

c = 2.9979 * 10^-5;      % [cm/fs]       
dw2 = 1 / (c*mean(diff(time))*pad);                        %defining the frequency step [cm-1]
w2 = ((-pad*dw2)/2:dw2:((pad*dw2)/2-dw2));      %frequency axis     [cm-1]                       

lpsvd_freq = fftshift(fft(lpsvd_vecpad));
freqvec = params.frequency.*3.33565*10^4; 
ampvec = params.amplitude; 
dampvec = 1./params.damping;

% figure
% subplot(1,2,1)
% scatter(time,datavec,5,'k','filled')
% hold on
% plot(time,real(lpsvd_temp),'r','LineWidth',2)
% box on
% xlabel('t2 (fs)')
% ylabel('signal amplitude (a.u.)')
% xlim([min(time) max(time)])
% set(gca, 'FontSize', 18);
% hold off
% 
% subplot(1,2,2)
% plot(w2,abs(lpsvd_freq),'r','LineWidth',2)
% xlabel('\omega/2\pic (cm^-^1)'); ylabel('FFT amplitude (a.u.)')
% xlim([0 1800])
% set(gca, 'FontSize', 18);

out.time = real(lpsvd_temp);
out.freq = abs(lpsvd_freq);
out.w2 = w2';
out.amplist = ampvec;
out.freqlist = freqvec;
out.dephaselist = dampvec;
out.lpsvdparam = params;

end
