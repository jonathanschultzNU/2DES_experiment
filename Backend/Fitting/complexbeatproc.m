function QBstruct = complexbeatproc(scans, lstruct, QBstruct, sigsqb)

switch sigsqb
    case 'rephasing'
         realisofield{1} = 'Rriso';
         imagisofield{1} = 'Riiso';
         sigtag{1} = 'dataw1w2w3Rtot';
    case 'non-rephasing'
         realisofield{1} = 'NRriso';
         imagisofield{1} = 'NRiiso';
         sigtag{1} = 'dataw1w2w3NRtot';
    case 'rephasing, non-rephasing'
         realisofield{1} = 'Rriso';
         realisofield{2} = 'NRriso';
         imagisofield{1} = 'Riiso';
         imagisofield{2} = 'Riiso';
         sigtag{1,1} = 'dataw1w2w3Rtot';
         sigtag{2,1} = 'dataw1w2w3NRtot';
         sigtag{1,2} = 't2Rtotiso';
         sigtag{2,2} = 't2NRtotiso';
end

for i=1:length(scans)
    for j = 1:length(sigtag)
        output = complexFFT_v2(QBstruct{1,i}.(realisofield{j}),QBstruct{1,i}.(imagisofield{j}),lstruct{1,i}.t2qb,lstruct{1,i}.w1slim,lstruct{1,i}.w3slim,QBstruct{1,i}.npad,lstruct{1,i}.nzero);
        QBstruct{1,i}.(sigtag{j,1}) = output.data_w1w2w3;
        QBstruct{1,i}.(sigtag{j,2}) = output.data_t2isotot;
        clear output
    end
end
end