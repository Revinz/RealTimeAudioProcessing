classdef Connection < Interactable % Class for the inConnection and outConnection of the nodes 
    properties
        Position;
        line;
        
        dragging = [];
        orPos = [];
        
    end
    
    methods
        function  obj = Connection(type,stringPos,pos,button,fcn)
            obj.anno = annotation(type,stringPos,pos,button,fcn,'Color','red','FaceColor',[.9 .9 .9]);
            obj.Position = pos;
            obj.line = annotation('line',[0 0],[0 0]);
            
        end
        % Update line position based on mouse coordinates
        function drag(obj)
            if ~isempty(obj.dragging)
                mouse = get(gcf,'CurrentPoint');
                posX = obj.anno.Position(1);
                posY = obj.anno.Position(2);
                obj.line.X = [posX mouse(1)];
                obj.line.Y = [posY mouse(2)];
            end

        end
        
         % (Not yet implemented) reset line if not connected to Connection node
         function drop(obj)
             if obj.connectedToNext == false
                 obj.line.Position = [0 0 0 0];
             else
             end
             obj.dragging = [];
             
         end
         
        function select(obj)
            obj.dragging = obj.anno;
            obj.orPos = get(gcf,'CurrentPoint');
        end
        
    end
    
end