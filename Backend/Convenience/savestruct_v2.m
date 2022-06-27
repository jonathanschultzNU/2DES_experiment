function savestruct_v2(saveopts, opts, lparams, Quantum_Beat_struct, Load_struct)

for i = 1:length(lparams.scans)

    lstruct = Load_struct{1,i};
    QBstruct = Quantum_Beat_struct{1,i};

    switch saveopts.chkpoint
    
        case 'one'
                
            struct.t2 = lstruct.t2;
            struct.t2s = lstruct.t2s;
            struct.nfiles = lstruct.nfiles;
            struct.t1 = lstruct.t1;
            struct.w1 = lstruct.w1;
            struct.w3 = lstruct.w3;
            struct.datat = lstruct.datat;
            struct.datapath = lstruct.datapath;
            struct.workuppath = lstruct.workuppath;

            savenamevect{1,1} = saveopts.savetitle;
            structnamevect{1,1} = 'struct';
        
        case 'two'
            
            switch opts.sigs

                case 'absorptive'

                case 'absorptive, rephasing, non-rephasing'

                    freqstructA.w1slim = lstruct.w1slim;
                    freqstructA.w3slim = lstruct.w3slim;
                    freqstructA.w2 = QBstruct.w2;
                    freqstructA.npad = QBstruct.npad;
                    freqstructA.workuppath = QBstruct.workuppath;
                    freqstructR = freqstructA;
                    freqstructNR = freqstructA;

                    freqstructA.dataw1w2w3A = QBstruct.dataw1w2w3A;
                    freqstructR.dataw1w2w3Rtot = QBstruct.dataw1w2w3Rtot;
                    freqstructNR.dataw1w2w3NRtot = QBstruct.dataw1w2w3NRtot;

                    timestruct.t2qb = lstruct.t2qb;
                    timestruct.Afits = QBstruct.Afits;
                    timestruct.Aiso = QBstruct.Aiso;
                    timestruct.t2Rtotiso = QBstruct.t2Rtotiso;
                    timestruct.t2NRtotiso = QBstruct.t2NRtotiso;

                    savenamevect{1,1} = [saveopts.savetitle 'freqA'];
                    savenamevect{1,2} = [saveopts.savetitle 'freqR'];
                    savenamevect{1,3} = [saveopts.savetitle 'freqNR'];
                    savenamevect{1,4} = [saveopts.savetitle 'time'];

                    structnamevect{1,1} = 'freqstructA';
                    structnamevect{1,2} = 'freqstructR';
                    structnamevect{1,3} = 'freqstructNR';
                    structnamevect{1,4} = 'timestruct';
                   
            end

        case 'pop_subt'

            struct.w1cut = lstruct.w1_cut;
            struct.w3cut = lstruct.w3_cut;
            struct.w1space = lstruct.w1space;
            struct.w3space = lstruct.w3space;
            struct.nzero = lstruct.nzero;
            struct.t2qb = lstruct.t2qb;
            struct.t2s = lstruct.t2s;

            savenamevect{1,1} = saveopts.savetitle;
            structnamevect{1,1} = 'struct';
    end

    for n = 1:length(savenamevect)

        scanchar = lparams.scans(i);
        savetitle = [num2str(scanchar) savenamevect{1,n}];
        structname = structnamevect{1,n};
    
        overwriteFile = true; % Default to overwriting or creating new file.
        if exist(fullfile(lstruct.workuppath,[char(savetitle) '.mat']),'file')
          % Ask user if they want to overwrite the file.
          promptMessage = sprintf('This file already exists:\n%s\nDo you want to overwrite it?', [char(saveopts.savetitle) '.mat']);
          titleBarCaption = 'Overwrite?';
          buttonText = questdlg(promptMessage, titleBarCaption, 'Yes', 'No','Yes');
          if strcmpi(buttonText, 'No')
            % User does not want to overwrite. 
            % Set flag to not do the write.
            overwriteFile = false;
          end
        end
        
        if overwriteFile
          % File does not exist yet, or the user wants to overwrite an existing file.
          datsave = fullfile(lparams.workuppath,[char(savetitle) '.mat']); 
        %   delete(datsave);
          save(datsave, structname); %,'-v7.3'
          disp('data saved')
        end
    end
end
end