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
            if ~isempty(obj.connectionLine)
                obj.disconnectLine();
                
            end
        end

        function drop(obj)
        end

        function drag(obj)
            
            
        end
        
        function connectLine(obj)

            
        end
        
        function disconnectLine(obj)
            try
                delete(obj.connectionLine);
                obj.connectionLine = [];
                obj.prevNode.outSocket.nextNode = [];
                obj.prevNode.outSocket.connectionLine = [];
            catch
            end
               
                
                if isa(obj.node, 'SpectrumNode')
                    obj.node.hideSpectrum();
                end
        end

            
    end
end