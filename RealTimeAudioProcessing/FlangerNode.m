classdef FlangerNode < Node    
    methods
                      
        function applyEffect(obj, buffer)
            flanger = Flanger();
            wetBuffer = flanger(buffer);
            
            
            obj.passToNextNode(wetBuffer);
            
        end
    end
end