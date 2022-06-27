function output = abs4framev1(data_t,t1,t2,w1,w3)

%initialize constants
c = 2.9979 * 10^-5;      % [cm/fs]
han1 = 1; %4;                 % Hanning value - increase or decrease based on fits shown in first figure
han2 = 1; %4;
num_t1 = length(t1);
num_t2 = length(t2);
num_w1 = length(w1);
num_w3 = length(w3);

data_t(:,1) = [];
data_t(end,:) = [];

% data_t = circshift(data_t,0,1);

%separate four frames and rotate so probe is along y-axis
data_frame1 = data_t(1:4:end,:)';
data_frame2 = data_t(2:4:end,:)';
data_frame3 = data_t(3:4:end,:)';
data_frame4 = data_t(4:4:end,:)';

%convert to 180 degree phase cycled sets
data_ch_1 = -log(data_frame1./data_frame2);
data_ch_2 = -log(data_frame3./data_frame4);

%% Troubleshooting

% pixel_num = 400;
% 
% figure(100)
% subplot(1,3,1)
% plot(t1,data_frame1(pixel_num,:),'k')
% hold on
% plot(t1,data_frame2(pixel_num,:))
% xlim([0 100])
% legend('frame1','frame2')
% hold off
% set(gca, 'FontSize', 10);
% width=350;
% height=220;
% set(gcf,'units','points','position',[0,0,width,height])
% 
% subplot(1,3,2)
% plot(t1,data_frame3(pixel_num,:),'k')
% hold on
% plot(t1,data_frame4(pixel_num,:),'b')
% xlim([0 100])
% legend('frame3','frame4')
% hold off
% set(gca, 'FontSize', 10);
% width=350;
% height=175;
% set(gcf,'units','points','position',[0,0,width,height])
% 
% subplot(1,3,3)
% plot(t1,data_ch_1(pixel_num,:),'k')
% hold on
% plot(t1,data_ch_2(pixel_num,:),'b')
% xlim([0 100])
% legend('ch1','ch2')
% hold off
% set(gca, 'FontSize', 10);
% width=350;
% height=175;
% set(gcf,'units','points','position',[0,0,width,height])

%% Continue

data_tot_t1w3 = -log((data_frame1./data_frame2).*(data_frame3./data_frame4)); %data_ch_1+data_ch_2;

%define windowing functions
win1 = hanning(2.*num_t1).^han1;            %create the symmetric Hann window
win_t1 = win1((length(win1)/2)+1:end);      %cut the Hann Window in half to match FID form


% pixel_num = 400;
% figure
% plot(t1,normdim(data_tot_t1w3(pixel_num,:)),'k')
% hold on
% plot(t1,win_t1,'k')


%window data in t1 domain - could be issues here? should window right before each FFT?
for j = 1:num_w3 
    for i = 1:num_t1
        data_tot_t1w3(j,i) = data_tot_t1w3(j,i)*win_t1(i);        
    end
end

% plot(t1,normdim(data_tot_t1w3(pixel_num,:)),'r')
% legend('before window','window','after window')
% hold off

%Fourier transform coherence time one data
n_pad = 2^8;                        %padding value
data_tot_t1w3_f = data_tot_t1w3;
data_tot_t1w3_f(:,1) = data_tot_t1w3_f(:,1)./2;
data_tot_t1w3_pad = zeros(length(w3),n_pad);
data_tot_t1w3_pad(:,1:length(t1))=data_tot_t1w3_f;
data_tot_w1w3 = fftshift(fft(data_tot_t1w3_pad,n_pad,2),2);

data_tot_w1w3(:,1) = [];

%output data
output.absorptive = data_tot_w1w3;

end