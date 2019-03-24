classdef (Abstract) ConnectionSocket < Interactable
    properties 
        connectionLine;
        node;
        socketOffset;
        socketSize = [.03 .05]; %The size of the sockets
    end
    
    methods
        function setSocketOffset(obj)
            obj.socketOffset = [(obj.socketSize(1)/2) (obj.socketSize(2)/2)];
        end 
        
        function newConnectionLine(obj, from)
            %Create new connection line from input / output socket to the
            %other one.
        end        
    end
    
    methods (Abstract)
        connectLine(obj);
        disconnectLine(obj);
    end
end