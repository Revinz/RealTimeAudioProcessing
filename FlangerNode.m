classdef FlangerNode < Node    
    methods
                      
        function applyEffect(obj, buffer)
            Flanger = flanger();
            wetBuffer = Flanger(buffer);
            
            
            obj.passToNextNode(wetBuffer);
            
        end
    end
end