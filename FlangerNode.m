classdef FlangerNode < Node    
    methods
                      
        function applyEffect(obj, buffer)
            TESTOUT = length(buffer)
            flanger = Flanger()
            wetBuffer = flanger.stepImpl(buffer);
            
            
            obj.passToNextNode(wetBuffer);
            
        end
    end
end