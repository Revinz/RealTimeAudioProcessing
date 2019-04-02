classdef Setting
    properties
        name;
        value;
        labelAnno;
        sliderAnno;
        bgAnno;
        
        minVal;
        maxVal;
        sliderStep;
        listener;
        
        settingAreaHeight = 0.2 %The height for the setting
        
        node;
    end
    
    methods
        function obj = Setting(name, default, min, max, step, node)
            global allSettings
            obj.name = name;
            obj.value = default;
            obj.minVal = min;
            obj.maxVal = max;
            obj.sliderStep = step;
            obj.node = node;
            allSettings{end+1} = obj;
 
        end
        
        function draw (obj, pos)            
            obj.labelAnno = annotation('textbox', 'String', obj.name, 'FitBoxToText', true, 'LineStyle', 'none');
            obj.labelAnno.Position = [obj.node.anno.Position(1) obj.node.anno.Position(2)-pos 0.1 0.05];
            obj.sliderAnno = uicontrol('style','slider', 'Units','Normalized',...
                'min', obj.minVal, 'max', obj.maxVal);
            obj.sliderAnno.Position = [obj.node.anno.Position(1) obj.node.anno.Position(2)-pos-0.05 0.15 0.05];
            
            set(obj.sliderAnno, 'value', obj.value);
            %Add listener so you can interact with the slider
            obj.listener = addlistener(obj.sliderAnno, 'Value', 'PostSet', @sliderValChange);
            
            for j = 1: length(obj.node.settings)
                if strcmp(obj.node.settings{j}.name, obj.name)
                    obj.node.settings{j}.labelAnno = obj.labelAnno;
                    obj.node.settings{j}.sliderAnno = obj.sliderAnno;
                    obj.node.settings{j}.sliderAnno.Visible = 'on';
                end
            end

            
            %Sets the value to be the current value while dragging the
            %slider
            function sliderValChange(src, event)
                
                if event.EventName == 'PostSet' 
                    %Find the setting in the node's settings and update it
                    %there. Not possible to update it through
                    %obj.value because this is a separate "workspace" where
                    %the class seems copied
                   
                    for i = 1: length(obj.node.settings)
                        if strcmp(obj.node.settings{i}.name, obj.name)
                            obj.node.settings{i}.value = get(event.AffectedObject, 'Value');
                        end
                    end
                end
            end
            
        end
        
        function obj = setValue(obj, value)
            obj.value = value;
            return
        end
        
        function updatePos(obj, setting, node, pos)
            setting.labelAnno.Position = [node.anno.Position(1) node.anno.Position(2)-pos 0.1 0.05];
            setting.sliderAnno.Position = [node.anno.Position(1) node.anno.Position(2)-pos-0.05 0.15 0.05];            
        end
        
        function hide(obj, setting)
            %Delete the annotations for the setting
            delete(setting.labelAnno);
            setting.sliderAnno.Visible = 'off';
                
                
        end
        
    end   
    
end