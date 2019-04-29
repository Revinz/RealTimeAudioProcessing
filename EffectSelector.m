classdef EffectSelector < Interactable
    properties
        Name;
        orPos = [];
        text;

    end
    methods
        
        function obj = EffectSelector(pos,name,fcn)
            annotation('ellipse','Position',[pos(1)+pos(3)/4 pos(2)+pos(4)/2  pos(3)/2 pos(4)/1.5],'LineWidth',0.6,'FaceColor', [0.62,0.75,0.76]);
            obj.text = annotation('textbox','Position',pos,'String',name,'HorizontalAlignment','center','LineStyle','none'); % Borderless textbox 
            obj.anno = annotation('ellipse','Position',[pos(1)+pos(3)/4 pos(2)+pos(4)/2  pos(3)/2 pos(4)/1.5],'ButtonDownFcn',fcn,'LineWidth',0.6);
            obj.Name = name;
        end
        
        function select(obj)
        end
            
        function drag(obj)

        end
        
        function drop(obj)
        end
    end
end