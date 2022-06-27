function QBstruct = popsubt_v1(method,dataw1t2w3,w1,w3,t2,npad,nzero)

    if strcmp('Exponential',method) == 1
        
        tic
        output = pop_fit_v2(dataw1t2w3,t2,w1,w3,npad,nzero,3);   %last number in input is the number of desired exponentials - note, you have to change the initial guesses manually within the popfitv2 code
        toc
        QBstruct.dataw1w2w3 = output.data_w1w2w3;
        QBstruct.w2 = output.w_beat;
        QBstruct.fits = output.beatfit;
        QBstruct.iso_traces = output.beat_iso;

    elseif strcmp('OAS',method) == 1
        
        c = 2.9979 * 10^-5;      % [cm/fs]                              
        dt = mean(diff(t2));                                %define time step (fs)
        dw = 1 / (c*dt*npad);                               %defining the frequency step [cm-1]
        QBstruct.w2 = ((-npad*dw)/2:dw:((npad*dw)/2-dw));   %frequency axis     [cm-1]
        
        datadimred = MDSDimRed(dataw1t2w3,w1,w3,t2);
        tic
        [expfits,OscFits,LowOscFits] = OAS(datadimred);
        toc
        QBstruct.expfits = unpackOAS(expfits,length(w3),length(w1),length(t2));
        QBstruct.lowoscfits = unpackOAS(LowOscFits,length(w3),length(w1),length(t2));
        QBstruct.fits = QBstruct.expfits+QBstruct.lowoscfits;
        QBstruct.oscfits = unpackOAS(OscFits,length(w3),length(w1),length(t2));
        QBstruct.iso_traces = dataw1t2w3-(QBstruct.fits);
        QBstruct.dataw1w2w3 = real_FFT_v1(QBstruct.iso_traces,t2,w1,w3,npad,nzero);
        
        %NOTE: could add a correction script here - if the highest peak is
        %less than a certain frequency, then run the single point pop subt
        
    else
        error('Specified method for population subtaction is not valid');
    end

end