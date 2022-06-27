function QBstruct = casepoptsubt(scans, lstruct, subt_method,sigsqb,npad)

QBstruct = cell(1,length(scans));
for i = 1:length(scans)
        QBstruct{1,i} = popsubtsigs_v1(subt_method,lstruct{1,i},npad,sigsqb);
        QBstruct{1,i}.npad = npad;
        QBstruct{1,i}.workuppath = lstruct{1,i}.workuppath;
        disp(['Populations subtracted for scan' num2str(scans(i))]);
        QBstruct{1,i}.w1slim = lstruct{1,i}.w1slim;
        QBstruct{1,i}.w3slim = lstruct{1,i}.w3slim;
end
end