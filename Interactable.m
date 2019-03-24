classdef (Abstract) Interactable < matlab.System
    properties 
        anno;
        connectedToNext;
        isSocket = false; % Check if a socket or a node was selected

    end
    
    methods (Abstract)
        drag(obj)
        
        drop(obj)
        
        select(obj);
    end
    
end