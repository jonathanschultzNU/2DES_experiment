function subtpred(subtnumber,method)
    
trend = load(strcat(method,'log.txt'));
    
if isempty(trend)
   disp('No data to predict from')
else

p = polyfit(trend(:,1),trend(:,2),1);
predtime = polyval(p,subtnumber);

disp('Predicted time required for subtraction is:')
disp([num2str(round(predtime,1)) 'seconds'])
disp([num2str(round(predtime/60,1)) 'minutes'])
   
end
end