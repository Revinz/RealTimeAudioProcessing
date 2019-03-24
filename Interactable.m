classdef (Abstract) Interactable < matlab.System
    properties 
        anno;
        connectedToNext;
    end
    
    methods (Abstract)
        drag(obj)
        
        drop(obj)
        
        select(obj);
    end
    
end