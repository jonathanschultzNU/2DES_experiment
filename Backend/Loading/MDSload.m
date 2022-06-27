function lstruct = MDSload(lparams,scan)

unpackStruct(lparams)


%add paths
addpath(lparams.datapath);
addpath(lparams.workuppath);

%Load info file and initialize

if scan < 10
    opts = detectImportOptions([num2str(Sdate) '#0' num2str(scan) '.info'],'FileType','text','ReadVariableNames',false);
    varname = opts.VariableNames{1,2};
    opts = setvartype(opts, varname, 'char');
    infotable = table2array(readtable([num2str(Sdate) '#0' num2str(scan) '.info'], opts));

elseif scan >= 10
    opts = detectImportOptions([num2str(Sdate) '#' num2str(scan) '.info'],'FileType','text','ReadVariableNames',false);
    varname = opts.VariableNames{1,2};
    opts = setvartype(opts, varname, 'char');
    infotable = table2array(readtable([num2str(Sdate) '#' num2str(scan) '.info'], opts));
end

t2loc = strcmp(infotable(:,1), 'Waiting Time Delays');
t1stepi = find(strcmp(infotable(:,1), 'Step Size (fs)'));
t1step = str2num(infotable{t1stepi,2});
t1maxi = find(strcmp(infotable(:,1), 'Final Delay (fs)'));
t1max = str2num(infotable{t1maxi,2});
rfi = find(strcmp(infotable(:,1),'Rotating Frame (Scanned)'));
if rfi
else
    rfi = find(strcmp(infotable(:,1),'Rotating Frame'));
end
rf = str2num(infotable{rfi,2});

if t2loc == 0
    t2loc = strcmp(infotable(:,1), 'Waiting Time Delay List');
end
t2ind = find(t2loc);

lstruct.t2 = str2num(infotable{t2ind,2});
inds = findinds(lstruct.t2,t2min,t2max);
lstruct.nfiles = inds(2)-inds(1)+1;
lstruct.t2 = lstruct.t2(inds(1):inds(2));
lstruct.t1 = 0:t1step:t1max;
freqaxes = mdsparams(t1step,rf,2^8);
unpackStruct(freqaxes);
lstruct.w1 = w1;
lstruct.w3 = w3;


% Import data set

if strcmp('ON',saveframedata) == 1
    numframe = 4;
elseif strcmp('OFF',saveframedata) == 1
    numframe = 1;
end

datat_load = zeros(length(lstruct.t1)*numframe+1,length(lstruct.w3)+1,lstruct.nfiles);


count=1;
progressbar % Init single bar
for k=inds(1):inds(2)
    datat_sub = zeros(length(lstruct.t1)*numframe+1,length(lstruct.w3)+1,subscans);
    if scan < 10
        if k<10
            for n = 1:subscans   
                if n < 10
                    datat_sub(:,:,n) = load([num2str(Sdate) '#0' num2str(scan) '_T0' num2str(k) '#00' num2str(n) '.scan']); 
                elseif n >= 10 && n < 100
                    datat_sub(:,:,n) = load([num2str(Sdate) '#0' num2str(scan) '_T0' num2str(k) '#0' num2str(n) '.scan']); 
                elseif n >= 100
                    datat_sub(:,:,n) = load([num2str(Sdate) '#0' num2str(scan) '_T0' num2str(k) '#' num2str(n) '.scan']); 
                end 
            end
       elseif k>=10
            for n = 1:subscans 
                if n < 10
                    datat_sub(:,:,n) = load([num2str(Sdate) '#0' num2str(scan) '_T' num2str(k) '#00' num2str(n) '.scan']); 
                elseif n >= 10
                    datat_sub(:,:,n) = load([num2str(Sdate) '#0' num2str(scan) '_T' num2str(k) '#0' num2str(n) '.scan']); 
                end 
            end
       end 
       datat_load(:,:,count) = mean(datat_sub,3);  
    elseif scan >= 10
        if k<10
            for n = 1:subscans
                if n < 10
                    datat_sub(:,:,n) = load([num2str(Sdate) '#' num2str(scan) '_T0' num2str(k) '#00' num2str(n) '.scan']);
%                     datat_sub(:,:,n) = load([num2str(Sdate) '#' num2str(scan) '#00' num2str(n) '.scan']);
                elseif n >= 10 && n < 100
                    datat_sub(:,:,n) = load([num2str(Sdate) '#' num2str(scan) '_T0' num2str(k) '#0' num2str(n) '.scan']); 
                elseif n >= 100
                    datat_sub(:,:,n) = load([num2str(Sdate) '#' num2str(scan) '_T0' num2str(k) '#' num2str(n) '.scan']); 
                end 
            end
        elseif k>=10
            for n = 1:subscans
                if n < 10
                    datat_sub(:,:,n) = load([num2str(Sdate) '#' num2str(scan) '_T' num2str(k) '#00' num2str(n) '.scan']); 
                elseif n >= 10
                    datat_sub(:,:,n) = load([num2str(Sdate) '#' num2str(scan) '_T' num2str(k) '#0' num2str(n) '.scan']); 
                end 
            end
        end 
       datat_load(:,:,count) = mean(datat_sub,3);  
    end
    count=count+1;
    
    if ismember(count,(0:round(lstruct.nfiles/10):1000)) == 1    
        progressbar(count/(lstruct.nfiles)) % UpSdate progress bar
    end
    if count== lstruct.nfiles
       progressbar(1)            % Close
    end
end

lstruct.datat = datat_load;
lstruct.datapath = [datapath num2str(Sdate)];
lstruct.workuppath = [workuppath num2str(Sdate)];
progressbar(1)            % Close
disp(['Scan' num2str(scan) 'loaded']);

end