function p = findind_v2(array,val)
    [~,p] = min(abs(array-val));
end