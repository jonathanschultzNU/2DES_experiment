function QBstruct = popsubtsigs_v1(method,lstruct,npad,sigsqb,fullres)

switch sigsqb
    case 'absorptive'
        sigfields = {'dataw1w3Aqbslim'};
        tags = {'A'};
%     case 'rephasing'
%         sigfields = 'dataw1w3Rrqbslim';
%         tags = [{'Rr'} {'Ri'}];
%     case 'non-rephasing'
%         sigfields = 'dataw1w3NRrqbslim';
%         tags = [{'NRr'}];
    case 'absorptive, rephasing, non-rephasing'
        sigfields = [{'dataw1w3Aqbslim'} {'dataw1w3Rqbrslim'} {'dataw1w3Rqbislim'} {'dataw1w3NRqbrslim'} {'dataw1w3NRqbislim'}];
        tags = [{'A'} {'Rr'} {'Ri'} {'NRr'} {'NRi'}];
    case 'absorptivefrob'
        if fullres == 1
            sigfields = {'dataw1w3Aqbfrob'};
        elseif fullres == 0
            sigfields = {'dataw1w3Aqbslimfrob'};
        end
        tags = {'Af'}; 
    case 'rephasingfrob'
        if fullres == 1
            sigfields = [{'dataw1w3Rqbrfrob'} {'dataw1w3Rqbifrob'}];
        elseif fullres == 0
            sigfields = [{'dataw1w3Rqbrslimfrob'} {'dataw1w3Rqbislimfrob'}];
        end
        tags = [{'Rrf'} {'Rif'}];
    case 'non-rephasingfrob'
        if fullres == 1
            sigfields = [{'dataw1w3NRqbrfrob'} {'dataw1w3NRqbifrob'}];
        elseif fullres == 0
            sigfields = [{'dataw1w3NRqbrslimfrob'} {'dataw1w3NRqbislimfrob'}];
        end
        tags = [{'NRrf'} {'NRif'}];
end

for n = 1:length(sigfields)
    
    if strcmp('Exponential',method) == 1
        
%         tic
        output = pop_fit_v2(lstruct.(sigfields{n}),lstruct.t2qb,lstruct.w1f,lstruct.w3f,npad,lstruct.nzero,3);   %last number in input is the number of desired exponentials - note, you have to change the initial guesses manually within the popfitv2 code
%         toc
        
        QBstruct.(['dataw1w2w3' tags{n}]) = output.data_w1w2w3;
        QBstruct.w2 = output.w_beat;
        QBstruct.([tags{n} 'fits']) = output.beatfit;
        QBstruct.([tags{n} 'iso']) = output.beat_iso;

    elseif strcmp('OAS',method) == 1
        
        c = 2.9979 * 10^-5;      % [cm/fs]                              
        dt = mean(diff(lstruct.t2qb));                                %define time step (fs)
        dw = 1 / (c*dt*npad);                               %defining the frequency step [cm-1]
        QBstruct.w2 = ((-npad*dw)/2:dw:((npad*dw)/2-dw));   %frequency axis     [cm-1]
        
        datadimred = MDSDimRed(lstruct.(sigfields{n}),lstruct.w1slim,lstruct.w3slim,lstruct.t2qb);
        [expfits,OscFits,LowOscFits] = OAS(datadimred);
        QBstruct.([tags{n} 'expfits']) = unpackOAS(expfits,length(lstruct.w3slim),length(lstruct.w1slim),length(lstruct.t2qb));
        QBstruct.([tags{n} 'lowoscfits']) = unpackOAS(LowOscFits,length(lstruct.w3slim),length(lstruct.w1slim),length(lstruct.t2qb));
        QBstruct.([tags{n} 'fits']) = QBstruct.([tags{n} 'expfits']); %+QBstruct.([tags{n} 'lowoscfits']);
        QBstruct.([tags{n} 'oscfits']) = unpackOAS(OscFits,length(lstruct.w3slim),length(lstruct.w1slim),length(lstruct.t2qb));
        QBstruct.([tags{n} 'iso']) = lstruct.(sigfields{n})-(QBstruct.([tags{n} 'fits']));
        QBstruct.(['dataw1w2w3' tags{n}]) = real_FFT_v1(QBstruct.([tags{n} 'iso']),lstruct.t2qb,lstruct.w1slim,lstruct.w3slim,npad,lstruct.nzero);
        
        %NOTE: could add a correction script here - if the highest peak is
        %less than a certain frequency, then run the single point pop subt
        
    else
        error('Specified method for population subtaction is not valid');
    end

end