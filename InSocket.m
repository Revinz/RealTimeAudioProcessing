classdef InSocket < ConnectionSocket
    properties
        prevNode % The next node this is connected to
    end
    
    methods
        function obj = InSocket(Node, type,stringPos,button,fcn)
            %Connects the node and the socket, to make it possible to
            %reference eachother
            obj.node = Node;
            obj.node.inSocket = obj;
            
            obj.setSocketOffset();
            
            %Draw the socket at the node position then instantly update the
            %socket positions
            obj.anno = annotation(type,stringPos,[obj.node.anno.Position(1) obj.node.anno.Position(2) obj.socketSize(1) obj.socketSize(2)],button,fcn,'Color','green','FaceColor',[.9 .9 .9]);
            obj.node.updateSocketPositions(); %Instantly update the socket positions
        end

        function select(obj)
            if isempty(obj.connectionLine)
                obj.newConnectionLine( 'in',[obj.anno.Position(1) obj.anno.Position(2)]);
                
            end
        end

        function drop(obj)
            connectLine(obj);
        end

        function drag(obj)
            
            if ~isempty(obj.connectionLine)
                mouse = get(gcf,'CurrentPoint');
                
                %Update end position of the end -- where it should connect
                %to the outSocket
                obj.connectionLine.Position(3) = mouse(1) - obj.connectionLine.Position(1);
                obj.connectionLine.Position(4) = mouse(2)- obj.connectionLine.Position(2);
                
            end
            
        end
        
        function connectLine(obj)
            
            connectToSocket = obj.checkForSocketInRange('OutSocket');
            
            if ~isempty(connectToSocket)
                %Update end of line position to be inside the out socket                
                obj.connectionLine.Position(3) = connectToSocket.anno.Position(1) + obj.socketOffset(1) - obj.connectionLine.Position(1);
                obj.connectionLine.Position(4) = connectToSocket.anno.Position(2) + obj.socketOffset(2)- obj.connectionLine.Position(2);
                obj.prevNode = connectToSocket.node;
                preNode = obj.prevNode
            else
                obj.disconnectLine();
            end
            
            
        end
        
        function disconnectLine(obj)
                delete(obj.connectionLine);
                obj.connectionLine = [];
                obj.prevNode = [];
        end

            
    end
end