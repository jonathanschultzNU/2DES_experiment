function output = pop_fit_v2(data_slim,t2,w1,w3,npad,n_cut_zero,numexp)

num_w1 = length(w1);
num_w3 = length(w3);

data_beat_freq = zeros(num_w3,num_w1,npad); 
beatfit = zeros(size(data_slim));
beat_iso = zeros(size(data_slim));

k = 1; 
han2 = 1;
win_2 = hanning(2 .* length(t2)) .^ han2;       %create the symmetric Hann window
win_2 = win_2((length(win_2) / 2) + 1 : end);     %cut the Hann Window in half to match FID form
options = optimset('MaxFunEvals',3000,'MaxIter',3000,'TolFun',1e-5,'TolX',1e-5,'Display','off');

if numexp == 1
    fit = @(a,t) a(1)+a(2).*exp(-t/a(3));
    fitout = @(p,t)p(1)+p(2).*exp(-t/p(3));
elseif numexp == 2
    fit = @(a,t) a(1)+a(2).*exp(-t/a(3))+a(4).*exp(-t/a(5));
    fitout = @(p,t) p(1)+p(2).*exp(-t/p(3))+p(4).*exp(-t/p(5));
elseif numexp == 3
    fit = @(a,t) a(1)+a(2).*exp(-t/a(3))+a(4).*exp(-t/a(5))+a(6).*exp(-t/a(7));
    fitout = @(p,t)p(1)+p(2).*exp(-t/p(3))+p(4).*exp(-t/p(5))+p(6).*exp(-t/p(7));
elseif numexp > 3
    error('not a valid number of exponential components');
end

% h = figure;
% set(gcf,'Visible','on')
%progressbar % Init single bar
for i = 1:num_w3
    for j = 1:num_w1
        
        dat(1,:) = data_slim(i,j,:);
        
        if dat(1) >= 0      %ESA
            g = [0,-0.02,200,0.02,1000,0.2,5000];
        elseif dat(1) < 0  %GSB/SE
            g = [0,-0.02,200,0.02,1000,-0.2,5000];
        end
         % minimized sum of squares of residuals
         
            ffun =@(a) sum((dat-fit(a,t2)).^2);
            [p] = fminsearch(ffun,g,options);
            
            beatfit(i,j,:) = fitout(p,t2);
%             plot(t2,dat)
%             hold on
%             plot(t2,fitout(p,t2))
%             hold on
            beat_iso(i,j,:) = data_slim(i,j,:) - beatfit(i,j,:);       
            q = zeros(1,npad);                            %initialize q
            tempvect(1,:)=beat_iso(i,j,:);
            q(n_cut_zero+1:n_cut_zero+length(t2)) = tempvect.*win_2';   %load beat into q r = r.*win_lpsvd';
            q(n_cut_zero+1) = q(n_cut_zero+1)./2;                                 %divide initial value by two to compensate trapezoidal rule
            data_beat_w = fftshift(fft(q));                 %Fourier transform and load into initialized/padded vector
            data_beat_freq(i,j,:) = data_beat_w;
               
        k=k+1;
        if ismember(k,(0:25:1000)) == 1    
            progressbar(k/(num_w1*num_w3)) % Update progress bar
        end
                    
    end
end

%Define FFT frequency axis
c = 2.9979 * 10^-5;      % [cm/fs]                              
dt = mean(diff(t2));                                                               %define time step (fs)
dw_beat = 1 / (c*dt*npad);                                           %defining the frequency step [cm-1]
w_beat = ((-npad*dw_beat)/2:dw_beat:((npad*dw_beat)/2-dw_beat));   %frequency axis     [cm-1]

progressbar(1)            % Close

output.data_w1w2w3 = data_beat_freq;
output.beatfit = beatfit;
output.beat_iso = beat_iso;
output.w_beat = w_beat;
output.win2 = win_2;