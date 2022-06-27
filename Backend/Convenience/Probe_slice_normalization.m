%normalize pump slices

spec = real(avespec.datw1t2w3(:,:,1));
w3 = (10^7)./lstruct{1,1}.w3_cut;
w1 = (10^7)./lstruct{1,1}.w1_cut;
% spec = matrix(2:end,2:end);
% w3 = matrix(2:end,1);
% w1 = matrix(1,2:end);
w3_slicefreqs = [525, 575, 635, 685, 730, 875];
w3_sliceinds = zeros(size(w3_slicefreqs));

for i = 1:length(w3_slicefreqs)
    w3_sliceinds(i) = findind(w3,w3_slicefreqs(i));
end

slices = zeros(length(w1),length(w3_slicefreqs));

for i = 1:length(w3_slicefreqs)
    slices(:,i) = spec(w3_sliceinds(i),:)./max(abs(spec(w3_sliceinds(i),:)));
end
