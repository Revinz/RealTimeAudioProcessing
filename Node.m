classdef Node < Interactable
    properties 
        Name;
        
        dryBuffer;
        wetBuffer;
        
        %Connection socket variables for annotations
        inSocket;
        outSocket;
                        
        %Variables for dragging/selecting/dropping
        orPos = []; %Original Position
        
    end
    methods
        function  obj = Node(pos,name,fcn)
            obj.anno = annotation('textbox','Position',pos,'String',name,'ButtonDownFcn',fcn);
            obj.Name = name;

        end
                
        function select(obj)
            selectWorking = obj.Name;
            obj.orPos = get(gcf,'CurrentPoint');
        end

        function drop(obj)

            newPos = get(gcf,'CurrentPoint');
            posDiff = newPos - obj.orPos;


            set(obj.anno,'Position',get(obj.anno,'Position') + [posDiff(1:2) 0 0]);
            updateSocketPositions(obj);

        end

        function drag(obj)
            newPos = get(gcf,'CurrentPoint');
            try
                posDiff = newPos - obj.orPos;

                obj.orPos = newPos;
                set(obj.anno,'Position',get(obj.anno,'Position') + [posDiff(1:2) 0 0]);
                updateSocketPositions(obj);

            catch
            end


        end
             
        function updateSocketPositions(obj)
            if ~isempty(obj.inSocket)
                obj.inSocket.anno.Position(1) = (obj.anno.Position(1)-obj.inSocket.socketOffset(1));
                obj.inSocket.anno.Position(2) = (obj.anno.Position(2)+obj.anno.Position(4)/2-obj.inSocket.socketOffset(2));        
            end
            
            if ~isempty(obj.outSocket)
                obj.outSocket.anno.Position(1) = (obj.anno.Position(1)+obj.anno.Position(3)-obj.outSocket.socketOffset(1));
                obj.outSocket.anno.Position(2) = (obj.anno.Position(2)+obj.anno.Position(4)/2-obj.outSocket.socketOffset(2));
            end
            
            obj.updateConnectionLines();
        end
        
        function updateConnectionLines(obj) % Not working!
            %Update endPosition of previous line
            if ~isempty(obj.inSocket)      
                obj.inSocket.connectionLine.Position(1) = (obj.anno.Position(1)-0.005);
                obj.inSocket.connectionLine.Position(2) = (obj.anno.Position(2)+obj.Position(4)/2);
            end
            
            %Update startPosition of nextLine
            if ~isempty(obj.outSocket)
                obj.outSocket.connectionLine.Position(1) = (obj.anno.Position(1)+obj.Position(3)-0.005);
                obj.outSocket.connectionLine.Position(2) = (obj.anno.Position(2)+obj.Position(4)/2);
            end            

        end  
                   
    end
    
     methods (Abstract)
         applyEffect(obj, buffer);
     end
end