function output = absprocv1(data_t,t1,t2,w1,w3)

%initialize constants
c = 2.9979 * 10^-5;      % [cm/fs]
han1 = 4;                 % Hanning value - increase or decrease based on fits shown in first figure
han2 = 4;
num_t1 = length(t1);
num_t2 = length(t2);
num_w1 = length(w1);
num_w3 = length(w3);

data_t(:,1) = [];
data_t(end,:) = [];
data_t = data_t';

%define windowing functions
win1 = hanning(2.*num_t1).^han1;            %create the symmetric Hann window
win_t1 = win1((length(win1)/2)+1:end);      %cut the Hann Window in half to match FID form

%window data in t1 domain - could be issues here? should window right before each FFT?
for i = 1:num_w3 
    for j = 1:num_t1
        data_t(i,j) = data_t(i,j)*win_t1(j);        
    end
end

%Fourier transform coherence time one data
n_pad = 2^8;                        %padding value
data_t_f = data_t;
% data_t_f(:,1) = data_t_f(:,1)./T2;
data_t_pad = zeros(length(w3),n_pad);
data_t_pad(:,1:length(t1))=data_t_f;
data_w1w3 = fftshift(fft(data_t_pad,n_pad,2),2);

data_w1w3(:,1) = [];

%output data
output.absorptive = data_w1w3;

end