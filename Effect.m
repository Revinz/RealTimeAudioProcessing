classdef (Abstract) Effect
    %UNTITLED7 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
       strength = 0.5 % How much should be applied (wet/dry)
    end
    
    methods(Abstract)
        Apply(obj)
    end
end

