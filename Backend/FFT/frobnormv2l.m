function fstruct = frobnormv2l(lstruct,QBstruct,frange,maxfreq,mode,redo,fullres,signal)

switch signal
    case 'absorptive'
        t2fsr = 'dataw1w3Aqbslim';
        t2ff = 'dataw1w3Aqb';
        w2field = 'dataw1w2w3A';
        fitsfield = 'Afits';
        isofield = 'Aiso';
    case 'rephasing'
        t2fsr = 'dataw1w3Rqbrslim';
        t2fsi = 'dataw1w3Rqbislim';
        t2ffr = 'dataw1w3Rqbr';
        t2ffi = 'dataw1w3Rqbi';
        w2field = 'dataw1w2w3Rtot';
        fitsfield = 'Rrfits';
        isofield = 'Rriso';
    case 'non-rephasing'
        t2fsr = 'dataw1w3NRqbrslim';
        t2fsi = 'dataw1w3NRqbislim';
        t2ffr = 'dataw1w3NRqbr';
        t2ffi = 'dataw1w3NRqbi';
        w2field = 'dataw1w2w3NRtot';
        fitsfield = 'NRrfits';
        isofield = 'NRriso';
    otherwise
end

freqdattemp = abs(QBstruct.(w2field));
w2 = QBstruct.w2;

switch fullres
    case 1
        
        indw1 = lstruct.w1_cut >= frange.w1cent-0.5*frange.boxdim & lstruct.w1_cut <= frange.w1cent+0.5*frange.boxdim;
        indw3 = lstruct.w3_cut >= frange.w3cent-0.5*frange.boxdim & lstruct.w3_cut <= frange.w3cent+0.5*frange.boxdim;
        
        switch signal
                case 'absorptive'
                    
                timedatatemp = lstruct.(t2ff);
                lstruct.([t2ff 'frob']) = timedatatemp(indw3,indw1,:);
                subt_method = 'Exponential'; %options are OAS and Exponential
                signal = strcat(signal,'frob');
                lstruct.w1f = lstruct.w1_cut(indw1);
                lstruct.w3f = lstruct.w3_cut(indw3);
                tstruct = popsubtsigs_v1(subt_method,lstruct,(length(lstruct.t2qb)+lstruct.nzero)*8,signal,fullres);
                freqdata = abs(tstruct.([w2field 'f']));
                w2 = tstruct.w2;
        
              case 'rephasing'
             
                timedatatemp = lstruct.(t2ffr);
                lstruct.([t2ffr 'frob']) = timedatatemp(indw3,indw1,:);
                timedatatemp = lstruct.(t2ffi);
                lstruct.([t2ffi 'frob']) = timedatatemp(indw3,indw1,:);
                subt_method = 'Exponential'; %options are OAS and Exponential
                signal = strcat(signal,'frob');

                lstruct.w1f = lstruct.w1_cut(indw1);
                lstruct.w3f = lstruct.w3_cut(indw3);

                tstruct = popsubtsigs_v1(subt_method,lstruct,(length(lstruct.t2qb)+lstruct.nzero)*2,signal,fullres);

                output = complexFFT_v2(tstruct.Rrfiso,tstruct.Rifiso,lstruct.t2qb,lstruct.w1f,lstruct.w3f,QBstruct.npad,lstruct.nzero);
                freqdata = abs(output.data_w1w2w3);
             
              case 'non-rephasing'
        end
        
        fstruct.w1f = lstruct.w1_cut(indw1);
        fstruct.w3f = lstruct.w3_cut(indw3);
        
    case 0
            
        indw1 = QBstruct.w1slim >= frange.w1cent-0.5*frange.boxdim & QBstruct.w1slim <= frange.w1cent+0.5*frange.boxdim;
        indw3 = QBstruct.w3slim >= frange.w3cent-0.5*frange.boxdim & QBstruct.w3slim <= frange.w3cent+0.5*frange.boxdim;

        
        if redo == 0
            
            freqdata = freqdattemp(indw3,indw1,:);

        elseif redo == 1
               
            switch signal
                case 'absorptive'
                    timedatatemp = lstruct.(t2fsr);
                    lstruct.([t2fsr 'frob']) = timedatatemp(indw3,indw1,:);
                    subt_method = 'Exponential'; %options are OAS and Exponential
                    signal = strcat(signal,'frob');

                    lstruct.w1f = lstruct.w1slim(indw1);
                    lstruct.w3f = lstruct.w3slim(indw3);

                    tstruct = popsubtsigs_v1(subt_method,lstruct,(length(lstruct.t2qb)+lstruct.nzero)*2,signal,fullres);
                    freqdata = abs(tstruct.([w2field 'f']));
                case 'rephasing'
                    timedatatemp = lstruct.(t2fsr);
                    lstruct.([t2fsr 'frob']) = timedatatemp(indw3,indw1,:);
                    timedatatemp = lstruct.(t2fsi);
                    lstruct.([t2fsi 'frob']) = timedatatemp(indw3,indw1,:);
                    subt_method = 'Exponential'; %options are OAS and Exponential
                    signal = strcat(signal,'frob');

                    lstruct.w1f = lstruct.w1slim(indw1);
                    lstruct.w3f = lstruct.w3slim(indw3);

                    tstruct = popsubtsigs_v1(subt_method,lstruct,(length(lstruct.t2qb)+lstruct.nzero)*2,signal,fullres);

                    output = complexFFT_v2(tstruct.Rrfiso,tstruct.Rifiso,lstruct.t2qb,lstruct.w1f,lstruct.w3f,QBstruct.npad,lstruct.nzero);
                    freqdata = abs(output.data_w1w2w3);
                case 'non-rephasing'
                    timedatatemp = lstruct.(t2fsr);
                    lstruct.([t2fsr 'frob']) = timedatatemp(indw3,indw1,:);
                    timedatatemp = lstruct.(t2fsi);
                    lstruct.([t2fsi 'frob']) = timedatatemp(indw3,indw1,:);
                    subt_method = 'Exponential'; %options are OAS and Exponential
                    signal = strcat(signal,'frob');

                    lstruct.w1f = lstruct.w1slim(indw1);
                    lstruct.w3f = lstruct.w3slim(indw3);

                    tstruct = popsubtsigs_v1(subt_method,lstruct,(length(lstruct.t2qb)+lstruct.nzero)*2,signal,fullres);

                    output = complexFFT_v2(tstruct.NRrfiso,tstruct.NRifiso,lstruct.t2qb,lstruct.w1f,lstruct.w3f,QBstruct.npad,lstruct.nzero);
                    freqdata = abs(output.data_w1w2w3);
            end
        end
        
        fstruct.w1f = QBstruct.w1slim(indw1);
        fstruct.w3f = QBstruct.w3slim(indw3);
        
    otherwise
end
    
if strcmp(mode,'freq')

indw2h = w2 >= 0;
w2h = w2(indw2h);
frobdata_h = freqdata(:,:,indw2h);
frobdata_c = zeros(size(freqdata));

    for i = 1:length(fstruct.w3f)
        for j = 1:length(fstruct.w1f)
            [value,ind] = max(frobdata_h(i,j,:));
            if w2h(ind) > maxfreq
                frobdata_c(i,j,:) = freqdata(i,j,:);
            end
        end
    end           
    
    frobnorm = zeros(length(w2),1);

    for k = 1:length(w2)
        tempmat = frobdata_c(:,:,k);
        frobnorm(k) = norm(tempmat,'fro');
    end
    
    fstruct.w2 = w2';
    fstruct.frobnorm = frobnorm;
    
    frangew1 = length(fstruct.w1f); frangew3 = length(fstruct.w3f);
    fstruct.froblims = cell(1+max([frangew1 frangew3]),2);
    fstruct.froblims(1,1) = {'w1'}; fstruct.froblims(1,2) = {'w3'}; 
    for n = 2:frangew1+1
        fstruct.froblims(n,1) = {fstruct.w1f(n-1)};
    end
    for n = 2:frangew3+1
        fstruct.froblims(n,2) = {fstruct.w3f(n-1)};
    end

elseif strcmp(mode,'time') 
    
% t2 = frobinput.t2;
% isodata = frobinput.beatiso;         isodata_c = zeros(size(isodata)); 
% timedata = frobinput.timedata;   timedata_c = zeros(size(timedata)); 
% fitdata = frobinput.beatfit;         fitdata_c = zeros(size(fitdata)); 
% 
%     for i = 1:length(w3slim)
%         for j = 1:length(w1slim)
%             [value,ind] = max(frobdata_h(i,j,:));
%             if w2h(ind) > maxfreq
%                 isodata_c(i,j,:) = isodata(i,j,:);
%                 timedata_c(i,j,:) = timedata(i,j,:);
%                 fitdata_c(i,j,:) = fitdata(i,j,:);
%             end
%         end
%     end           
%     
%     isomean = zeros(length(t2),1);
%     timemean = zeros(length(t2),1);
%     fitmean = zeros(length(t2),1);
% 
%     for k = 1:length(t2)
%         tempmat = isodata_c(:,:,k);
%         isomean(k) = mean(tempmat(:));
%         tempmat2 = timedata_c(:,:,k);
%         timemean(k) = mean(tempmat2(:));
%         tempmat3 = fitdata_c(:,:,k);
%         fitmean(k) = mean(tempmat3(:));
%     end
% 
%     npad2 = length(w2);
%     q = zeros(1,npad2);                            %initialize q
%     q(frobinput.nzero+1:frobinput.nzero+length(t2)) = frobinput.win2.*isomean;   
%     q(frobinput.nzero+1) = q(frobinput.nzero+1)./2;                                 %divide initial value by two to compensate trapezoidal rule
%     timefrobFFT = fftshift(fft(q));                 %Fourier transform and load into initialized/padded vector
% 
%     Frobstruct.t2 = t2;
%     Frobstruct.frobnormtime = isomean;
%     Frobstruct.frobnormpop = timemean;
%     Frobstruct.frobnormfit = fitmean;
%     Frobstruct.w2 = w2;
%     Frobstruct.timefrobFFT = abs(timefrobFFT);
% 
%     figure(5)
%     subplot(1,3,1)
%     scatter(t2,timemean,'filled','k')
%     hold on
%     plot(t2,fitmean,'r','Linewidth',2)
%     xlabel('time (fs)')
%     ylabel('FFT norm amplitude (a.u.)')
%     xlim([100 1500])
%     set(gca, 'FontSize', 18);
%     hold off
% 
%     subplot(1,3,2)
%     plot(t2,isomean,'k','Linewidth',2)
%     xlabel('time (fs)')
%     ylabel('FFT norm amplitude (a.u.)')
%     xlim([100 1500])
%     set(gca, 'FontSize', 18);
% 
%     subplot(1,3,3)
%     plot(w2,abs(timefrobFFT),'k','Linewidth',2)
%     xlabel('time (fs)')
%     ylabel('FFT norm amplitude (a.u.)')
%     xlim([0 1800])
%     set(gca, 'FontSize', 18);
%     
%     set(gcf, 'Position',  [0, 200, 1600, 400])

end

