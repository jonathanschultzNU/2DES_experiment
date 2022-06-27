function output = smooth_2D_v4(dataw1w3,nfiles,order,method,framelen)


dataw1w3_sm = zeros(size(dataw1w3));       %initialize matrix for data smoothed in one dimension

if strcmp('GF',method) == 1
     
    for k=1:nfiles 
        znan = dataw1w3(:,:,k);
        z = inpaint_nans(znan,3);
        dataw1w3_sm(:,:,k) = smoothdata(z,1,'gaussian',order,'omitnan');
    end
    
elseif strcmp('SG',method) == 1
    
    for k=1:nfiles      
        dataw1w3_sm(:,:,k) = sgolayfilt(dataw1w3(:,:,k),order,framelen,kaiser(framelen,2*framelen));
    end
end

output = dataw1w3_sm;