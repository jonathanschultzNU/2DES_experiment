function slicedata = pumpslices(lstruct,lparams,opts)

pumpinds = zeros(size(opts.pumpvals));
slicedata = zeros(numel(lstruct{1,1}.w3_cut)+1,numel(lstruct{1,1}.t2s)+1,numel(opts.pumpvals));

for i = 1:length(lparams.scans)

    for j = 1:numel(opts.pumpvals)
        pumpinds(j) = findind(opts.pumpvals(j),lstruct{1,i}.w1_cut);
        tempmat = real(lstruct{1,1}.data_w1w3Acut(:,pumpinds(j),:));
        tempmat = permute(tempmat,[1,3,2]);
        slicedata(2:end,2:end,j) = tempmat;
        slicedata(2:end,1,j) = lstruct{1,1}.w3_cut;
        slicedata(1,2:end,j) = lstruct{1,1}.t2s;

        savearray_v2(slicedata(:,:,j),['scan' num2str(lparams.scans(i)) '_pumpslice' num2str(opts.pumpvals(j)) '.dat'],[lparams.workuppath '\']);
    end

end
end