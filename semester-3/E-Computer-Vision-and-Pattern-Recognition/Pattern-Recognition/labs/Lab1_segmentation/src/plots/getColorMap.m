function [ colorMap ] = getColorMap( colorMapName )
%GETCOLORMAP returns a colormap defined by name. Possible are predefined
% matlab colormaps or own colormaps.
%   
%   Input:
%       colorMapName:   Name of colormap as string, or a colormap array.
%
%   Output:
%       colorMap    :   Colormap array.
%
% by Stefan Schmohl 2018.


% Designed for occupancy:
if strcmp(colorMapName, 'V2DLabels')

    colorMap = [1 1 1;
                1 1 1;
                0 0 1;
                0 1 1;
                0 1 0;
                1 1 0;
                1 0 0];
              
%  Designed for probability density function:
elseif strcmp(colorMapName, 'pdf')
    
    colorMap = parula;
    
%  Designed for Binary:
elseif strcmp(colorMapName, 'binary')
    
    colorMap = getColorMap('occ');
    colorMap = [1 1 1; colorMap(end,:)];
    
else
    colorMap = colormap(colorMapName);
end



end

