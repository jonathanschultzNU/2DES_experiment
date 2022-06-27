function output = rnr4framev4(data_t,t1,t2,w1,w3)

%initialize constants
c = 2.9979 * 10^-5;      % [cm/fs]
han1 = 2;                 % Hanning value - increase or decrease based on fits shown in first figure
% han2 = 50;
num_t1 = length(t1);
% num_t2 = length(t2);
% num_w1 = length(w1);
num_w3 = length(w3);

data_t(:,1) = [];
data_t(end,:) = [];

% data_t = circshift(data_t,-4,1);

%separate four frames and rotate so probe is along y-axis
data_frame1 = data_t(1:4:end,:)';
data_frame2 = data_t(2:4:end,:)';
data_frame3 = data_t(3:4:end,:)';
data_frame4 = data_t(4:4:end,:)';

%convert to 180 degree phase cycled sets
data_phi_0_w3t1 = -log(data_frame1./data_frame2);
data_phi_pi_w3t1 = -log(data_frame3./data_frame4);

%% Troubleshooting

% pixel_num = 325;
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
% plot(t1,data_phi_0_w3t1(pixel_num,:),'k')
% hold on
% plot(t1,data_phi_pi_w3t1(pixel_num,:),'b')
% xlim([0 100])
% legend('ch1','ch2')
% hold off
% set(gca, 'FontSize', 10);
% width=350;
% height=175;
% set(gcf,'units','points','position',[0,0,width,height])

%%

%inverse Fourier transform to t3 domain %%
data_phi_0_t3t1 = zeros(length(w3),num_t1);  %initialize Fourier transformed data matrix
data_phi_pi_t3t1 = zeros(length(w3),num_t1);  %initialize Fourier transformed data matrix

for i = 1:num_t1
    q1(1:num_w3) = data_phi_0_w3t1(:,i);      %load columns of t1 into q for Fourier transform
    %q1(1) = q1(1)./2;                         %divide initial values by two to compensate trapezoidal rule
    data_phi_0_t3t1(:,i) = ifftshift(ifft(q1));    %Fourier transform and load into initialized matrix   
    
    q2(1:num_w3) = data_phi_pi_w3t1(:,i);      %load columns of t1 into q for Fourier transform
    %q2(1) = q2(1)./2;                         %divide initial values by two to compensate trapezoidal rule
    data_phi_pi_t3t1(:,i) = ifftshift(ifft(q2));    %Fourier transform and load into initialized matrix   
end

%define t3 values %%
dw3 = mean(diff(w3));
dt3 = 1 / (c*dw3*length(w3));                  %defining the frequency step [cm-1]
t3 = ((-length(w3)*dt3)/2:dt3:((length(w3)*dt3)/2-dt3)); %frequency axis     [fs]
num_t3 = length(t3);

% enforce Causality
for i = 1:num_t3
    if t3(i)<0
       data_phi_0_t3t1(i,:) = 0;
       data_phi_pi_t3t1(i,:) = 0;
    end
end

%combine in time domain to generate rephasing and non-rephasing matrices
data_t1t3_R = data_phi_0_t3t1+1i.*data_phi_pi_t3t1;
data_t1t3_NR = data_phi_0_t3t1-1i.*data_phi_pi_t3t1;

%define windowing functions
win1 = hanning(2.*num_t1).^han1;            %create the symmetric Hann window
win_t1 = win1((length(win1)/2)+1:end);      %cut the Hann Window in half to match FID form
% win3 = hanning(num_t3).^han2;    
% win_t3 = win3((length(win3)/2)+1:end);
% win_t3_fix = zeros(num_t3,1);
% win_t3_fix(num_t3/2:end-1,1) = win_t3(:,1);
% win_t3_fix = flipud(win_t3_fix);
% win_t3_fix = win_t3_fix';

% for j = 1:num_t1                            
%     for i = 1:num_t3 
%         data_t1t3_R(i,j) =  win_t3_fix(i)*data_t1t3_R(i,j);        
%         data_t1t3_NR(i,j) =  win_t3_fix(i)*data_t1t3_NR(i,j);
%     end
% end

%Fourier transform coherence time three data %%
data_t1w3_R = zeros(length(w3),length(t1)); %initialize Fourier transformed data matrix
data_t1w3_NR = zeros(length(w3),length(t1));  %initialize Fourier transformed data matrix

for i = 1:num_t1
    q_R = zeros(num_w3,1);                  %initialize q - array that holds data to FT
    q_R(1:num_w3) = data_t1t3_R(:,i);      %load columns of t1 into q for Fourier transform
    q_NR = zeros(num_w3,1);                  %initialize q - array that holds data to FT
    q_NR(1:num_w3) = data_t1t3_NR(:,i);      %load columns of t1 into q for Fourier transform
    q_R(1) = q_R(1)./2;                      %divide initial values by two to compensate trapezoidal rule
    q_NR(1) = q_NR(1)./2;                      %divide initial values by two to compensate trapezoidal rule
    data_t1w3_R(:,i) = (fft(fftshift(q_R)));    %Fourier transform and load into initialized matrix   
    data_t1w3_NR(:,i) = (fft(fftshift(q_NR)));    %Fourier transform and load into initialized matrix   
end

%window data in t1 domain - could be issues here? should window right before each FFT?

for j = 1:num_t3 
    for i = 1:num_t1
        data_t1w3_R(j,i) = data_t1w3_R(j,i)*win_t1(i);        
        data_t1w3_NR(j,i) = data_t1w3_NR(j,i)*win_t1(i);
    end
end

%Fourier transform coherence time one data  - try subtracting constant
%average?
npad_t1 = 2^8;                         %padding value
data_w1w3_R = zeros(num_w3,npad_t1);   %initialize Fourier transformed data matrix
data_w1w3_NR = zeros(num_w3,npad_t1);  %initialize Fourier transformed data matrix

for i = 1:num_w3
    q_R = zeros(1,npad_t1);                       %initialize q - array that holds data to FT
    q_R(1:num_t1) = data_t1w3_R(i,:);             %load columns of t1 into q for Fourier transform
    q_NR = zeros(1,npad_t1);                      %initialize q - array that holds data to FT
    q_NR(1:num_t1) = data_t1w3_NR(i,:);           %load columns of t1 into q for Fourier transform
    q_R(1) = q_R(1)./2;                           %divide initial values by two to compensate trapezoidal rule
    q_NR(1) = q_NR(1)./2;                         %divide initial values by two to compensate trapezoidal rule
    data_w1w3_R(i,:) = fftshift(fft(q_R));      %Fourier transform and load into initialized matrix   
    data_w1w3_NR(i,:) = fftshift(fft(q_NR));    %Fourier transform and load into initialized matrix   
end

%cut data
data_w1w3_R(:,1) = [];
data_w1w3_NR(:,1) = [];

%generate absorptive and dispersive data
data_w1w3_A = real(fliplr(data_w1w3_R) + (data_w1w3_NR));
% data_w1w3_A = real(fliplr(data_w1w3_NR) + (data_w1w3_R));
data_w1w3_D = imag(fliplr(data_w1w3_R) + (data_w1w3_NR));

%output data
output.rephasing = fliplr(data_w1w3_R);
output.nonrephasing = data_w1w3_NR;
output.absorptive = data_w1w3_A;
output.dispersive = data_w1w3_D;

end