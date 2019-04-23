classdef EffectSelector < Interactable
    properties
        Name;
        orPos = [];

    end
    methods
        
        function obj = EffectSelector(pos,name,fcn)
            obj.anno = annotation('textbox','Position',pos,'String',name,'ButtonDownFcn',fcn,'HorizontalAlignment','center');
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

