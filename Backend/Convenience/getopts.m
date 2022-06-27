function opt = getopts(option)

switch option
    case 'frobnorm'
        opt.error = 'std';
        opt.handle     = figure;
        opt.color_area = [128 193 219]./255;    % Blue theme
        opt.color_line = [ 52 148 186]./255;
        opt.alpha      = 0.5;
        opt.line_width = 2;

    otherwise
end