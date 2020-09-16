classdef ImageSource < data.potsdam.DataSource
    %DATASOURCE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties

    end
    
    methods
        function obj = ImageSource(folderName, formatString)
            obj@data.potsdam.DataSource(folderName, formatString)
        end
        
        function data = loadData(obj, row, column)
            data = loadImage(obj, row, column);
        end
        
        function image = loadImage(obj, row, column)
            global PATH2DATA
            fname = obj.rc2fname(row, column);
            fpath = [PATH2DATA, filesep, obj.folderName, filesep, fname];
            image = imread(fpath);
        end
        
    end
end

