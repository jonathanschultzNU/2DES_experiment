function QBstruct = NanReplace(QBstruct,scans,opts)

switch opts.nan
    case 1

    for n = 1:length(scans)
        switch opts.sigplot
            case 'absorptive'
                
            QBstruct{1,n}.dataw1w2w3Ac = NaN(size(QBstruct{1,n}.dataw1w2w3A)); 
            
                for i = 1:numel(QBstruct{1,n}.w3slim)
                    for j = 1:numel(QBstruct{1,n}.w1slim)
                        [~,ind] = max(QBstruct{1,n}.dataw1w2w3A(i,j,:));
                        if abs(QBstruct{1,n}.w2(ind)) > opts.cutoff_freq 
                            QBstruct{1,n}.dataw1w2w3Ac(i,j,:) = QBstruct{1,n}.dataw1w2w3A(i,j,:);
                        end
                    end
                end           
           
            case 'absorptive, rephasing, non-rephasing'
                
                QBstruct{1,n}.dataw1w2w3Ac = NaN(size(QBstruct{1,n}.dataw1w2w3A)); 
                for i = 1:numel(QBstruct{1,n}.w3slim)
                    for j = 1:numel(QBstruct{1,n}.w1slim)
                        [~,ind] = max(QBstruct{1,n}.dataw1w2w3A(i,j,:));
                        if abs(QBstruct{1,n}.w2(ind)) > opts.cutoff_freq 
                            QBstruct{1,n}.dataw1w2w3Ac(i,j,:) = QBstruct{1,n}.dataw1w2w3A(i,j,:);
                        end
                    end
                end   

                QBstruct{1,n}.dataw1w2w3Rtotc = NaN(size(QBstruct{1,n}.dataw1w2w3Rtot)); 
                for i = 1:numel(QBstruct{1,n}.w3slim)
                    for j = 1:numel(QBstruct{1,n}.w1slim)
                        [~,ind] = max(QBstruct{1,n}.dataw1w2w3A(i,j,:));
                        if abs(QBstruct{1,n}.w2(ind)) > opts.cutoff_freq 
                            QBstruct{1,n}.dataw1w2w3Rtotc(i,j,:) = QBstruct{1,n}.dataw1w2w3Rtot(i,j,:);
                        end
                    end
                end     

                QBstruct{1,n}.dataw1w2w3NRtotc = NaN(size(QBstruct{1,n}.dataw1w2w3NRtot)); 
                for i = 1:numel(QBstruct{1,n}.w3slim)
                    for j = 1:numel(QBstruct{1,n}.w1slim)
                        [~,ind] = max(QBstruct{1,n}.dataw1w2w3A(i,j,:));
                        if abs(QBstruct{1,n}.w2(ind)) > opts.cutoff_freq 
                            QBstruct{1,n}.dataw1w2w3NRtotc(i,j,:) = QBstruct{1,n}.dataw1w2w3NRtot(i,j,:);
                        end
                    end
                end       
            
            otherwise
                disp('Invalid case expression')
        end

    end

    case 0

        for n = 1:length(scans)
            switch opts.sigplot
                case 'absorptive'
                    QBstruct{1,n}.dataw1w2w3Ac = QBstruct{1,n}.dataw1w2w3A;
    
                case 'absorptive, rephasing, non-rephasing'
                    QBstruct{1,n}.dataw1w2w3Ac = QBstruct{1,n}.dataw1w2w3A;
                    QBstruct{1,n}.dataw1w2w3Rtotc = QBstruct{1,n}.dataw1w2w3Rtot;
                    QBstruct{1,n}.dataw1w2w3NRtotc = QBstruct{1,n}.dataw1w2w3NRtot;
            end
        end

end

end

