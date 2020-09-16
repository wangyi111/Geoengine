function [  ] = saveAndPrintFigure( figure, path2Save, varargin )
%SAVENANDPRINTFIGURE save figure and print it to png and eps.
%
%   Input:
%       figure          :   Figure handle.
%       path2Save       :   Path where the plot will be saved.
%
% by Stefan Schmohl 2017

p = inputParser;
p.addParameter('fig', false);
p.addParameter('png', true);
p.addParameter('bmp', false);
p.addParameter('eps', false);
p.parse(varargin{:});
args = p.Results;

   
% Save figure and print:
if args.fig
    saveas(figure,         sprintf('%s.fig',path2Save),'fig');
end
if args.png
    print(figure, '-r600', sprintf('%s.png',path2Save),'-dpng');
end
if args.bmp
    print(figure, '-r600', sprintf('%s.bmp',path2Save),'-dbmp');
end
if args.eps
    print(figure, '-r600', sprintf('%s.eps',path2Save),'-depsc');
end

end

