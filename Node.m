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
            obj.anno = annotation(type,stringPos,pos,stringName,name,button,fcn,'BackgroundColor','blue','FaceAlpha',0.3)
            obj.Name = name;
            obj.Position = pos;
            obj.inConnection = annotation('ellipse','Position',[obj.Position(1)-0.005 obj.Position(2)+obj.Position(4)/2 .01 .015],'Color','red','FaceColor',[.9 .9 .9]);
            obj.outConnection = annotation('ellipse','Position',[obj.Position(1)+obj.Position(3)-0.005 obj.Position(2)+obj.Position(4)/2 .01 .015],'Color','red','FaceColor',[.9 .9 .9]);

        end
        
        function select(obj)
            selectWorking = obj.Name
            obj.dragging = obj;
            obj.orPos = get(gcf,'CurrentPoint');

        end
        function drop(obj)
            insideDrop = 'inside Drop'
            if ~isempty(obj.dragging)
                dropWorking = obj.Name
                newPos = get(gcf,'CurrentPoint');
                posDiff = newPos - obj.orPos;


                set(obj.dragging,'Position',get(obj.dragging,'Position') + [posDiff(1:2) 0 0]);
                updateConnectionCircles(obj);

                obj.dragging = [];
            end

        end

        function drag(obj)
            insideDrag = 'inside Drag'
            if ~isempty(obj.dragging)
                dragWorking = obj.Name
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
            obj.inConnection.Position(1) = (obj.Position(1)-0.005);
            obj.inConnection.Position(2) = (obj.Position(2)+obj.Position(4)/2);
            obj.outConnection.Position(1) = (obj.Position(1)+obj.Position(3)-0.005);
            obj.outConnection.Position(2) = (obj.Position(2)+obj.Position(4)/2);
        end
        

    end
end