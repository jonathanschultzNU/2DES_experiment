function savestruct(chkopts, sigs, struct, savename, filetype)

workuppath = struct.workuppath;
frm = true;

if chkopts.chk == 1
    
    switch sigs
        case 'absorptive' 
            fieldsrm = {'datat','datw1w3A'};
        case 'absorptive, rephasing, non-rephasing'
            fieldsrm = {'datat','datw1w3A','datw1w3R','datw1w3NR','datw1w3Asm','datw1w3Rsm','datw1w3NRsm','dataw1w3A_norm','dataw1w3R_norm','dataw1w3NR_norm','dataw1w3_plot'};
        case 'simulations'
            fieldsrm = {'datat','datw1w3A','datw1w3R','datw1w3NR'};
        case 'not applicable'
            frm = false;
    end
    
    if frm
        for n = 1:length(fieldsrm)
            struct = rmfield(struct,fieldsrm(n));
        end
    end

elseif chkopts.chk == 2
    
    switch sigs
        case 'absorptive' 
            fieldsrm = {'A'};
        case 'absorptive, rephasing, non-rephasing'
            fieldsrm = {'A','Rr','Ri','NRr','NRi'};
        case 'not applicable'
            frm = false;
    end
    
    if frm
         for n = 1:length(fieldsrm)
             struct = rmfield(struct,strcat(fieldsrm(n),'expfits'));
             struct = rmfield(struct,strcat(fieldsrm(n),'lowoscfits'));
             struct = rmfield(struct,strcat(fieldsrm(n),'oscfits'));
             struct = rmfield(struct,strcat('dataw1w2w3',fieldsrm(n)));
             
             switch chkopts.partnum
                 case 0
                 case 1
                     struct = rmfield(struct,strcat(fieldsrm(n),'fits'));

                     if n ==1
                        switch sigs
                         case 'absorptive, rephasing, non-rephasing'
                                struct = rmfield(struct,'dataw1w2w3Rtot');
                                struct = rmfield(struct,'dataw1w2w3NRtot');
                                savename = [savename 'iso'];
                         otherwise
                        end
                     end
                 case 2
                     struct = rmfield(struct,strcat(fieldsrm(n),'iso'));

                    if n ==1
                     switch sigs
                         case 'absorptive, rephasing, non-rephasing'
                                struct = rmfield(struct,'dataw1w2w3Rtot');
                                struct = rmfield(struct,'dataw1w2w3NRtot');
                                savename = [savename 'fits'];
                         otherwise
                     end
                    end
                 otherwise
             end
         end
         struct = rmfield(struct,'w2');
         struct = rmfield(struct,'npad');
         struct = rmfield(struct,'workuppath');
         struct = rmfield(struct,'w1slim');
         struct = rmfield(struct,'w3slim');
    end
    
elseif chkopts.chk == 3
        
    switch sigs
        case 'absorptive' 
            fieldsrm = {'A'};
        case 'absorptive, rephasing, non-rephasing'
            fieldsrm = {'A','Rr','Ri','NRr','NRi'};
        case 'not applicable'
            frm = false;
    end
    
    if frm
         for n = 1:length(fieldsrm)
            struct = rmfield(struct,strcat(fieldsrm(n),'expfits'));
            struct = rmfield(struct,strcat(fieldsrm(n),'lowoscfits'));
            struct = rmfield(struct,strcat(fieldsrm(n),'oscfits'));
            struct = rmfield(struct,strcat(fieldsrm(n),'iso'));
            struct = rmfield(struct,strcat(fieldsrm(n),'fits'));
         end

         struct = rmfield(struct,'dataw1w2w3Rr');
         struct = rmfield(struct,'dataw1w2w3Ri');
         struct = rmfield(struct,'dataw1w2w3NRr');
         struct = rmfield(struct,'dataw1w2w3NRi');

         switch chkopts.partnum
             case 0
             case 1
                 struct = rmfield(struct,'w2');
                 struct = rmfield(struct,'npad');
                 struct = rmfield(struct,'workuppath');
                 struct = rmfield(struct,'w1slim');
                 struct = rmfield(struct,'w3slim');
                 struct = rmfield(struct,'t2Rtotiso');
                 struct = rmfield(struct,'t2NRtotiso');
                 struct = rmfield(struct,'dataw1w2w3A');
                 savename = [savename 'RNR'];
                 
             case 2
                 struct = rmfield(struct,'dataw1w2w3Rtot');
                 struct = rmfield(struct,'dataw1w2w3NRtot');
                 struct = rmfield(struct,'t2Rtotiso');
                 struct = rmfield(struct,'t2NRtotiso');
                 savename = [savename 'Aparams'];
         end
    end
end

overwriteFile = true; % Default to overwriting or creating new file.
if exist(fullfile(workuppath,[char(savename) filetype]),'file')
  % Ask user if they want to overwrite the file.
  promptMessage = sprintf('This file already exists:\n%s\nDo you want to overwrite it?', [char(savename) filetype]);
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
  datsave = fullfile(workuppath,[char(savename) filetype]); 
%   delete(datsave);
  save(datsave, 'struct'); %,'-v7.3'
  disp('data saved')
end
end