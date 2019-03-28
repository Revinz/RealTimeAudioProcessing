classdef LowpassNode < Node  
    
    properties
        cutoffHz = 200;
    end
    methods
                      
        function applyEffect(obj, buffer)
            global Fs;
            wetBuffer = lowpass(buffer, obj.cutoffHz, Fs);            
            
            obj.passToNextNode(wetBuffer);
            
        end
    end
end