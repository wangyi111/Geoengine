classdef DataSource
    %DATASOURCE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        formatString
        folderName
    end
    
    methods
        function obj = DataSource(folderName, formatString)
            obj.formatString = formatString;
            obj.folderName = folderName;
        end
        
        function data = loadData(obj, row, column)
            data = [];
        end
        
        function fname = rc2fname(obj, row, column)
            fname = sprintf(obj.formatString, row, column); 
        end
    end
end

