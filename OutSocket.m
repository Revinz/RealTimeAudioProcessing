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
            if ~isempty(obj.connectionLine)
                obj.disconnectLine();               
            end
        end

        function drop(obj)
            obj.connectLine();
        end

        function drag(obj)
            if isempty(obj.connectionLine)
                obj.newConnectionLine('out',[obj.anno.Position(1) obj.anno.Position(2)]);
            end
            
            if ~isempty(obj.connectionLine)
                mouse = get(gcf,'CurrentPoint');
                
                %Update the endposition of the line
                obj.connectionLine.Position(3) = mouse(1) - obj.connectionLine.Position(1);
                obj.connectionLine.Position(4) = mouse(2) - obj.connectionLine.Position(2);
                
            end
            
        end
        
        function connectLine(obj)
            
            connectToSocket = obj.checkForSocketInRange('InSocket');
                        
            if ~isempty(connectToSocket) && ~isempty(obj.connectionLine)
                
                %If a connection to it already exists, remove it
                 if ~isempty(connectToSocket.connectionLine)
                     connectToSocket.prevNode.outSocket.disconnectLine();
                 end
                
                %Update end of line position to be inside the in socket                
                obj.connectionLine.Position(3) = connectToSocket.anno.Position(1) + obj.socketOffset(1) - obj.connectionLine.Position(1);
                obj.connectionLine.Position(4) = connectToSocket.anno.Position(2) + obj.socketOffset(2) - obj.connectionLine.Position(2);
                connectToSocket.connectionLine = obj.connectionLine;
                obj.nextNode = connectToSocket.node;
                connectToSocket.prevNode = obj.node;
            else
                try
                obj.disconnectLine();
                catch
                end
            end
            
        end
        
        function disconnectLine(obj)
                delete(obj.connectionLine);
                obj.connectionLine = [];
                
                
                if isa(obj.nextNode, 'SpectrumNode')
                    obj.nextNode.hideSpectrum();
                end
                
                obj.nextNode = [];
                obj.nextNode.inSocket.connectionLine = [];
        end
        

            
    end
end