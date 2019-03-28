classdef HighpassNode < Node  
    
    properties
        cutoffHz = 200;
    end
    methods
                      
        function applyEffect(obj, buffer)
            global Fs;
            wetBuffer = highpass(buffer, obj.cutoffHz, Fs);            
            
            obj.passToNextNode(wetBuffer);
            
        end
    end
end