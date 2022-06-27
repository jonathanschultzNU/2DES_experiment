function output = smooth_2D_v3(dataw1w3,nfiles,order,method,framelen)


dataw1w3_sm = zeros(size(dataw1w3));       %initialize matrix for data smoothed in one dimension

if strcmp('GF',method) == 1
     
    for k=1:nfiles  
        dataw1w3_sm(:,:,k) = smoothdata(dataw1w3(:,:,k),1,'gaussian',order);
    end
    
elseif strcmp('SG',method) == 1
    
    for k=1:nfiles      
        dataw1w3_sm(:,:,k) = sgolayfilt(dataw1w3(:,:,k),order,framelen,kaiser(framelen,2*framelen));
    end
end

output = dataw1w3_sm;