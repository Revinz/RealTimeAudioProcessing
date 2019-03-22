classdef (Abstract) Interactable < matlab.System
    properties 
        anno;

    end
    
    methods (Abstract)
        drag(obj)
        
        drop(obj)
        
        select(obj);
    end
    
end