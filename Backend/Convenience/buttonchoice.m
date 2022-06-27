function out = buttonchoice(varargin)


options = cell2mat(varargin(1:2:end));
strings = varargin(2:2:end);
out = cell(1,sum(options(:) == 1));
count = 1;
for i = 1:length(options)
    if options(i) == 1
        out{count} = strings{i};
        count = count+1;
    end
end

if length(out) > 1
    out = [sprintf('%s, ',out{1:end-1}),out{end}];
else
    out = sprintf(out{1});
end

end

