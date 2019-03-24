classdef InSocket < ConnectionSocket
    methods
        function obj = InSocket(Node, type,stringPos,button,fcn)
            %Connects the node and the socket, to make it possible to
            %reference eachother
            obj.node = Node;
            obj.node.inSocket = obj;
            obj.socket = 0; % in socket = 0
            obj.isSocket = true; 

            obj.setSocketOffset();
            
            %Draw the socket at the node position then instantly update the
            %socket positions
            obj.anno = annotation(type,stringPos,[obj.node.anno.Position(1) obj.node.anno.Position(2) obj.socketSize(1) obj.socketSize(2)],button,fcn,'Color','green','FaceColor',[.9 .9 .9]);
            obj.node.updateSocketPositions(); %Instantly update the socket positions
        end

        function select(obj)
            
        end

        function drop(obj)

        end

        function drag(obj)
            if ~isempty(obj.connectionLine)
%                 obj.newConnectionLine('In');
                
            else
                %Drag the current line to change where the input needs to
                %go
            end
        end
        
        function connectLine(obj,firstSocket,secondSocket)
                 
            if (firstSocket.socket == 0 && secondSocket.socket == 1)
                obj.newConnectionLine(firstSocket,secondSocket);
            end
        end
        
        function disconnectLine(obj)
        end

            
    end
end