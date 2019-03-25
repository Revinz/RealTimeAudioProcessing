classdef (Abstract) ConnectionSocket < Interactable
    properties 
        connectionLine;
        node;
        socketOffset;
        socketSize = [.03 .05]; %The size of the sockets       
        
        maxConnectionRange = 0.05;
    end
    
    methods
        function setSocketOffset(obj)
            obj.socketOffset = [(obj.socketSize(1)/2) (obj.socketSize(2)/2)];
        end 
        
        function newConnectionLine(obj, from, socketPos)
            %Create new connection line from input / output socket to the
            %other one.
            mouse = get(gcf,'CurrentPoint');
            
            %Position(n)
            %startOfLine x = 1, in y = 3
            %endOfLine x = 2, y = 4
            if strcmp(from, 'out')                                                                     
                obj.connectionLine = annotation('line',[socketPos(1)+obj.socketOffset(1) mouse(1)], [socketPos(2)+obj.socketOffset(2) mouse(2)]);
            elseif strcmp(from, 'in') %Not used anymore
                obj.connectionLine = annotation('line',[mouse(1) socketPos(1)+obj.socketOffset(1)], [mouse(2) socketPos(2)+obj.socketOffset(2)]);
            end
        end
        
        %return the socket that is in range of the mouse position
        function socketInRange = checkForSocketInRange(obj,socketType)
            global Interactables;
            socketInRange = [];
            for i = 1:length(Interactables)
                if isa(Interactables{i}, socketType)
                    mouse = get(gcf,'CurrentPoint');
                    socketPos = [Interactables{i}.anno.Position(1) + Interactables{i}.socketOffset(1) Interactables{i}.anno.Position(2) + Interactables{i}.socketOffset(2)]; 
                    distance = pdist([mouse; socketPos],'euclidean');
                    if distance < obj.maxConnectionRange
                        socketInRange = Interactables{i};
                        return
                    end
                end
            end
            
            return
        end
    end            

    
    methods (Abstract)
        connectLine(obj);
        disconnectLine(obj);
    end
end