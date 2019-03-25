classdef InputNode < Node
    methods
        
        function retrieveBuffer(obj)
            
            %Get the input buffer here
            
            
            %Pass it on
            
            obj.applyEffect(dryBuffer);
        end
        
        function applyEffect(obj, buffer)
            nodeName = obj.Name
            obj.outSocket.nextNode.applyEffect(buffer)
            
        end
    end
end