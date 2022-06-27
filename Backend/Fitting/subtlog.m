function subtlog(totaltime,subtnumber,method)

a = [subtnumber totaltime];
dlmwrite(strcat(method,'log.txt'),a,'-append','newline','pc')
disp('Time logged')

end