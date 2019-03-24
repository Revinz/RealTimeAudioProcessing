classdef Node < Interactable
    properties 
        Name;
        Position;
        
        %Connection socket variables
        inConnection;
        outConnection;
                        
        %Variables for dragging/selecting/dropping
        dragging = []; %Most likely useless
        orPos = []; %Most likely useless     
    end
    methods
        function  obj = Node(type,stringPos,pos,stringName,name,button,fcn)
            obj.anno = annotation(type,stringPos,pos,stringName,name,button,fcn,'BackgroundColor','blue','FaceAlpha',0.3);
            obj.Name = name;
            obj.Position = pos;

        end
                
        function select(obj)
            selectWorking = obj.Name;
            obj.dragging = obj.anno;
            obj.orPos = get(gcf,'CurrentPoint');
        end

        function drop(obj)
            if ~isempty(obj.dragging)
                newPos = get(gcf,'CurrentPoint');
                posDiff = newPos - obj.orPos;


                set(obj.dragging,'Position',get(obj.dragging,'Position') + [posDiff(1:2) 0 0]);
                updateConnectionCircles(obj);

                obj.dragging = [];
            end

        end

        function drag(obj)
            if ~isempty(obj.dragging)
                newPos = get(gcf,'CurrentPoint');
                try
                    posDiff = newPos - obj.orPos;

                    obj.orPos = newPos;
                    set(obj.dragging,'Position',get(obj.dragging,'Position') + [posDiff(1:2) 0 0]);
                    updateConnectionCircles(obj);

                catch
                end

            end

        end
        
        
        function updateConnectionCircles(obj)
            obj.inConnection.anno.Position(1) = (obj.anno.Position(1)-0.005);
            obj.inConnection.anno.Position(2) = (obj.anno.Position(2)+obj.Position(4)/2);
            obj.outConnection.anno.Position(1) = (obj.anno.Position(1)+obj.Position(3)-0.005);
            obj.outConnection.anno.Position(2) = (obj.anno.Position(2)+obj.Position(4)/2);
            
            obj.inConnection.line.Position(1) = obj.inConnection.anno.Position(1);
            obj.inConnection.line.Position(2) = (obj.anno.Position(2)+obj.Position(4)/2);
            obj.outConnection.line.Position(1) = (obj.anno.Position(1)+obj.Position(3)-0.005);
            obj.outConnection.line.Position(2) = (obj.anno.Position(2)+obj.Position(4)/2);
        end
            
    end
end