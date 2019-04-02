classdef ConnectionLine < Interactable
    properties 
        %The sockets it is connected to
        inSocket;
        outSocket;
        
        inPos;
        outPos;
    end
    
    methods
        
        
        function drag(obj)

        end
        
        function drop(obj)
        end
        
        function select(obj);
        end 
    end
    
end