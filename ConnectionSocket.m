classdef (Abstract) ConnectionSocket < Interactable
    properties
        selectCount = 0;
        connectionLine;
        node;
        socket; % socket value: 0 = in, 1 = out
        socketOffset;
        socketSize = [.03 .05]; %The size of the sockets      
    end
    
    methods
        function setSocketOffset(obj)
            obj.socketOffset = [(obj.socketSize(1)/2) (obj.socketSize(2)/2)];
        end 
        
        function newConnectionLine(obj,firstSocket,secondSocket)
            %Create new connection line from input / output socket to the
            %other one.
            obj.connectionLine = annotation('line',[firstSocket.anno.Position(1) secondSocket.anno.Position(1)],[firstSocket.anno.Position(2) secondSocket.anno.Position(2)]);
            
        end        
    end
    
    methods (Abstract)
        connectLine(obj);
        disconnectLine(obj);
    end
end