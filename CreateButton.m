classdef CreateButton < Interactable
    properties
        posX = [];
        posY = [];
        vertical;
        horizontal;
        isClicked = false;
        color = 'g';
    end
    methods
        
        function obj = CreateButton(pos,fcn)
            annotation('ellipse','Position',pos,'Color',obj.color,'FaceColor', [0.62,0.75,0.76]);
            obj.vertical = annotation('line',[pos(1)+pos(3)/2 pos(1)+pos(3)/2],[pos(2)+pos(4)/4 pos(2)+pos(4)-pos(4)/4],'Color',obj.color); % lines to make the cross
            obj.horizontal = annotation('line',[pos(1)+pos(3)/4 pos(1)+pos(3)-pos(3)/4],[pos(2)+pos(4)/2 pos(2)+pos(4)/2],'Color',obj.color);
            obj.posY = obj.vertical.Position;
            obj.posX = obj.horizontal.Position;
            obj.anno = annotation('ellipse','Position',pos,'ButtonDownFcn',fcn,'Color',obj.color);

        end
        
        function resetDefault(button)
            button.anno.Color = 'g';
            button.vertical.Color = 'g';
            button.horizontal.Color = 'g';
            button.vertical.Position =  button.posY;
            button.horizontal.Position =  button.posX;
            button.isClicked = false;
        end
        
        function select(obj)
            if obj.isClicked
                resetDefault(obj);
                
            else
                
                % The plus sign becomes an X and the colors change from
                % green to red
                obj.anno.Color = 'r';
                obj.vertical.Color = 'r';
                obj.horizontal.Color = 'r';
                
                length = obj.vertical.Position(4);
                obj.vertical.Position(1) = obj.vertical.Position(1)-length/4;
                obj.vertical.Position(3) = obj.vertical.Position(3)+length/2;
                
                obj.horizontal.Position(2) = obj.horizontal.Position(2)+length/2;
                obj.horizontal.Position(4) = obj.horizontal.Position(4)-length;
                
                obj.isClicked = true;
                
                
            end
            

        end
            
        function drag(obj)

        end
        
        function drop(obj)
        end
    end
end