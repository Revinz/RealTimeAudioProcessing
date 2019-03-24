classdef OutSocket < ConnectionSocket
    methods
        function obj = OutSocket(Node, type,stringPos,button,fcn)
            %Connects the node and the socket, to make it possible to
            %reference eachother
            obj.node = Node;
            obj.node.outSocket = obj;
            obj.socket = 1; % out socket = 1
            obj.isSocket = true; 

            obj.setSocketOffset();
            
            %Draw the socket
            obj.anno = annotation(type,stringPos,[obj.node.anno.Position(1) obj.node.anno.Position(2) obj.socketSize(1) obj.socketSize(2)],button,fcn,'Color','red','FaceColor',[.9 .9 .9]);
            obj.node.updateSocketPositions();
        end
        
        function select(obj)

        end

        function drop(obj)

        end

        function drag(obj)
            if ~isempty(obj.connectionLine)
%                 obj.newConnectionLine('Out');             
            else
                %Drag the current line to change where the output needs to
                %go
            end
        end
        
        function connectLine(obj,firstSocket,secondSocket)
                 
            if (firstSocket.socket == 1 && secondSocket.socket == 0)
                obj.newConnectionLine(firstSocket,secondSocket);
            end
        end
        
        function disconnectLine(obj)
        end
        

            
    end
end