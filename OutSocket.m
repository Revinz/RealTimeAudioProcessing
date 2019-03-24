classdef OutSocket < ConnectionSocket
    
    properties
        nextNode %The node before this one that is connected to it
    end
    
    methods
        function obj = OutSocket(Node, type,stringPos,button,fcn)
            %Connects the node and the socket, to make it possible to
            %reference eachother
            obj.node = Node;
            obj.node.outSocket = obj;
           
            obj.setSocketOffset();
            
            %Draw the socket
            obj.anno = annotation(type,stringPos,[obj.node.anno.Position(1) obj.node.anno.Position(2) obj.socketSize(1) obj.socketSize(2)],button,fcn,'Color','red','FaceColor',[.9 .9 .9]);
            obj.node.updateSocketPositions();
        end
        
        function select(obj)
            if isempty(obj.connectionLine)
                obj.newConnectionLine('out',[obj.anno.Position(1) obj.anno.Position(2)]);
                
            end
        end

        function drop(obj)
            connectLine(obj);
            obj.connectionLine = [];
        end

        function drag(obj)
            
            if ~isempty(obj.connectionLine)
                mouse = get(gcf,'CurrentPoint');
                
                %Updates the start of point of the line
                
                %Find the change in position
                changeInPos = [obj.connectionLine.Position(1)-mouse(1) obj.connectionLine.Position(2) - mouse(2)];
                
                %Update the start of the line
                obj.connectionLine.Position(1) = mouse(1);
                obj.connectionLine.Position(2) = mouse(2);
                
                %Update the end of the line, since it is relative to the
                %start point of the line
                obj.connectionLine.Position(3) = obj.connectionLine.Position(3) + changeInPos(1);
                obj.connectionLine.Position(4) = obj.connectionLine.Position(4) + changeInPos(2);

                
            end
            
        end
        
        function connectLine(obj)
            
            connectToSocket = obj.checkForSocketInRange('InSocket')
            
            if ~isempty(connectToSocket)
                
                %Update end of line position to be inside the out socket                
                obj.connectionLine.Position(1) = connectToSocket.anno.Position(1) + obj.socketOffset(1);
                obj.connectionLine.Position(2) = connectToSocket.anno.Position(2) + obj.socketOffset(2);

                obj.nextNode = connectToSocket.node;
                nextNode = obj.nextNode
            else
                obj.disconnectLine();
            end
            
        end
        
        function disconnectLine(obj)
                delete(obj.connectionLine);
                obj.connectionLine = [];
                obj.nextNode = [];
        end
        

            
    end
end