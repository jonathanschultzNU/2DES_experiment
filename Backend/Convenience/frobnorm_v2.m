function fstruct = frobnorm_v2(lstruct,QBstruct,frange,opts)

switch opts.sigplot
    case 'absorptive'
        t2fsr = 'dataw1w3Aqbslim';
        t2ff = 'dataw1w3Aqb';
        w2field = 'dataw1w2w3A';
        fitsfield = 'Afits';
        isofields{1,1} = 'Aiso';
    case 'rephasing'
        t2fsr = 'dataw1w3Rqbrslim';
        t2fsi = 'dataw1w3Rqbislim';
        t2ffr = 'dataw1w3Rqbr';
        t2ffi = 'dataw1w3Rqbi';
        w2field = 'dataw1w2w3Rtot';
        isofields{1,1} = 't2Rtotiso';
    case 'non-rephasing'
        t2fsr = 'dataw1w3NRqbrslim';
        t2fsi = 'dataw1w3NRqbislim';
        t2ffr = 'dataw1w3NRqbr';
        t2ffi = 'dataw1w3NRqbi';
        w2field = 'dataw1w2w3NRtot';
        isofields{1,1} = 't2NRtotiso';
    otherwise
end

freqdattemp = abs(QBstruct.(w2field));
w2 = QBstruct.w2;

if length(isofields) == 1
    timedattemp = QBstruct.(isofields{1,1});
else
    timedattemp = QBstruct.(isofields{1,1})+1i.*QBstruct.(isofields{1,2});
end

% switch opts.fullres
%     case 1
%         
%         indw1 = lstruct.w1_cut >= frange.w1cent-0.5*frange.boxdim & lstruct.w1_cut <= frange.w1cent+0.5*frange.boxdim;
%         indw3 = lstruct.w3_cut >= frange.w3cent-0.5*frange.boxdim & lstruct.w3_cut <= frange.w3cent+0.5*frange.boxdim;
%         
%         switch opts.sigplot
%                 case 'absorptive'
%                     
%                 timedatatemp = lstruct.(t2ff);
%                 lstruct.([t2ff 'frob']) = timedatatemp(indw3,indw1,:);
%                 subt_method = 'Exponential'; %options are OAS and Exponential
%                 signal = strcat(opts.sigplot,'frob');
%                 lstruct.w1f = lstruct.w1_cut(indw1);
%                 lstruct.w3f = lstruct.w3_cut(indw3);
%                 tstruct = popsubtsigs_v1(subt_method,lstruct,frange.pad,signal,fullres);
%                 freqdata = abs(tstruct.([w2field 'f']));
%                 w2 = tstruct.w2;
%         
%               case 'rephasing'
%              
%                 timedatatemp = lstruct.(t2ffr);
%                 lstruct.([t2ffr 'frob']) = timedatatemp(indw3,indw1,:);
%                 timedatatemp = lstruct.(t2ffi);
%                 lstruct.([t2ffi 'frob']) = timedatatemp(indw3,indw1,:);
%                 subt_method = 'Exponential'; %options are OAS and Exponential
%                 signal = strcat(opts.sigplot,'frob');
% 
%                 lstruct.w1f = lstruct.w1_cut(indw1);
%                 lstruct.w3f = lstruct.w3_cut(indw3);
% 
%                 tstruct = popsubtsigs_v1(subt_method,lstruct,frange.pad,opts.sigplot,opts.fullres);
% 
%                 output = complexFFT_v2(tstruct.Rrfiso,tstruct.Rifiso,lstruct.t2qb,lstruct.w1f,lstruct.w3f,QBstruct.npad,lstruct.nzero);
%                 freqdata = abs(output.data_w1w2w3);
%              
%               case 'non-rephasing'
%         end
%         
%         fstruct.w1f = lstruct.w1_cut(indw1);
%         fstruct.w3f = lstruct.w3_cut(indw3);
        
%     case 0
            
        indw1 = QBstruct.w1slim >= frange.w1cent-0.5*frange.w1dim & QBstruct.w1slim <= frange.w1cent+0.5*frange.w1dim;
        indw3 = QBstruct.w3slim >= frange.w3cent-0.5*frange.w3dim & QBstruct.w3slim <= frange.w3cent+0.5*frange.w3dim;

        
        if opts.redosubt == 0
            
            freqdata = freqdattemp(indw3,indw1,:);
            timedata = timedattemp(indw3,indw1,:);

        elseif opts.redosubt == 1
               
            switch opts.sigplot
                case 'absorptive'
                    timedatatemp = lstruct.(t2fsr);
                    lstruct.([t2fsr 'frob']) = timedatatemp(indw3,indw1,:);
                    signal = strcat(opts.sigplot,'frob');

                    lstruct.w1f = lstruct.w1slim(indw1);
                    lstruct.w3f = lstruct.w3slim(indw3);

                    tstruct = popsubtsigs_v1(opts.subt_method,lstruct,frange.pad,signal,opts.fullres);
                    freqdata = abs(tstruct.([w2field 'f']));
                    w2 = tstruct.w2;
                    timedata = tstruct.Afiso;

                case 'rephasing'
                    timedatatemp = lstruct.(t2fsr);
                    lstruct.([t2fsr 'frob']) = timedatatemp(indw3,indw1,:);
                    timedatatemp = lstruct.(t2fsi);
                    lstruct.([t2fsi 'frob']) = timedatatemp(indw3,indw1,:);
                    signal = strcat(opts.sigplot,'frob');

                    lstruct.w1f = lstruct.w1slim(indw1);
                    lstruct.w3f = lstruct.w3slim(indw3);

                    tstruct = popsubtsigs_v1(opts.subt_method,lstruct,frange.pad,signal,opts.fullres);

                    output = complexFFT_v2(tstruct.Rrfiso,tstruct.Rifiso,lstruct.t2qb,lstruct.w1f,lstruct.w3f,frange.pad,lstruct.nzero);
                    freqdata = abs(output.data_w1w2w3);
                    timedata = tstruct.Rrfiso+1i.*tstruct.Rifiso;
                    w2 = tstruct.w2;

                case 'non-rephasing'
                    timedatatemp = lstruct.(t2fsr);
                    lstruct.([t2fsr 'frob']) = timedatatemp(indw3,indw1,:);
                    timedatatemp = lstruct.(t2fsi);
                    lstruct.([t2fsi 'frob']) = timedatatemp(indw3,indw1,:);
                    subt_method = 'Exponential'; %options are OAS and Exponential
                    signal = strcat(opts.sigplot,'frob');

                    lstruct.w1f = lstruct.w1slim(indw1);
                    lstruct.w3f = lstruct.w3slim(indw3);

                    tstruct = popsubtsigs_v1(opts.subt_method,lstruct,frange.pad,signal,opts.fullres);

                    output = complexFFT_v2(tstruct.NRrfiso,tstruct.NRifiso,lstruct.t2qb,lstruct.w1f,lstruct.w3f,frange.pad,lstruct.nzero);
                    freqdata = abs(output.data_w1w2w3);
                    timedata = tstruct.NRrfiso+1i.*tstruct.NRifiso;
                    w2 = tstruct.w2;
            end
        end
        
        fstruct.w1f = QBstruct.w1slim(indw1);
        fstruct.w3f = QBstruct.w3slim(indw3);
        
%     otherwise
% end

switch opts.domain
    case 'Frequency'

    indw2h = w2 >= 0;
    w2h = w2(indw2h);
    frobdata_h = freqdata(:,:,indw2h);
    frobdata_c = zeros(size(freqdata));
    
        for i = 1:length(fstruct.w3f)
            for j = 1:length(fstruct.w1f)
                [value,ind] = max(frobdata_h(i,j,:));
                if w2h(ind) > opts.cutoff_freq
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
        fstruct.FFTnorm = frobnorm;
        
        frangew1 = length(fstruct.w1f); frangew3 = length(fstruct.w3f);
        fstruct.froblims = cell(1+max([frangew1 frangew3]),2);
        fstruct.froblims(1,1) = {'w1'}; fstruct.froblims(1,2) = {'w3'}; 
        for n = 2:frangew1+1
            fstruct.froblims(n,1) = {fstruct.w1f(n-1)};
        end
        for n = 2:frangew3+1
            fstruct.froblims(n,2) = {fstruct.w3f(n-1)};
        end

    case 'Time'

            indw2h = w2 >= 0;
            w2h = w2(indw2h);
            frobdata_h = freqdata(:,:,indw2h);
            avedata_c = zeros(size(timedata));
    
        for i = 1:length(fstruct.w3f)
            for j = 1:length(fstruct.w1f)
                [value,ind] = max(frobdata_h(i,j,:));
                if w2h(ind) > opts.cutoff_freq
                    avedata_c(i,j,:) = timedata(i,j,:);
                end
            end
        end           
        
        avenorm = zeros(length(lstruct.t2qb),1);
    
        for k = 1:length(lstruct.t2qb)
            tempmat = avedata_c(:,:,k);
            avenorm(k) = mean(mean(tempmat));
        end
        
        c = 2.9979 * 10^-5;      % [cm/fs]       
        dw2 = 1 / (c*mean(diff(lstruct.t2qb))*frange.pad);                        %defining the frequency step [cm-1]
        time_w2 = ((-frange.pad*dw2)/2:dw2:((frange.pad*dw2)/2-dw2));      %frequency axis     [cm-1] 
        avenorm_FFT = real_FFT_v1(permute(avenorm,[3,2,1]),lstruct.t2qb,1,1,frange.pad,lstruct.nzero);
        
        fstruct.w2 = time_w2;
        fstruct.FFTnorm = abs(avenorm_FFT);
        fstruct.timedata = avenorm;
        
        frangew1 = length(fstruct.w1f); frangew3 = length(fstruct.w3f);
        fstruct.froblims = cell(1+max([frangew1 frangew3]),2);
        fstruct.froblims(1,1) = {'w1'}; fstruct.froblims(1,2) = {'w3'}; 
        for n = 2:frangew1+1
            fstruct.froblims(n,1) = {fstruct.w1f(n-1)};
        end
        for n = 2:frangew3+1
            fstruct.froblims(n,2) = {fstruct.w3f(n-1)};
        end
end

end

