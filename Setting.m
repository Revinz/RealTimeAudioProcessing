classdef Setting
    properties
        name;
        value;
        labelAnno;
        sliderAnno;
        
        minVal;
        maxVal;
        sliderStep;
        listener;
       
        settingAreaHeight = 0.2 %The height for the setting
        
        node;
    end
    
    methods
        function obj = Setting(name, value, min, max, step, node)
            global allSettings
            obj.name = name;
            obj.value = value;
            obj.minVal = min;
            obj.maxVal = max;
            obj.sliderStep = step;
            obj.node = node;
            allSettings{end+1} = obj;
        end
        
        function draw (obj, pos)
            obj.labelAnno = annotation('textbox', [(0.575-0.05) 0.25 0.1 0.05], 'String', 'Rate (Hz)', 'FitBoxToText', true, 'LineStyle', 'none');
            obj.sliderAnno = uicontrol('style','slider', 'Units','Normalized','position',[pos 0.2 0.15 0.05],...
                'min', obj.minVal, 'max', obj.maxVal);
            set(obj.sliderAnno, 'value', 0.5);
            %Add listener so you can interact with the slider
            addlistener(obj.sliderAnno, 'Value', 'PostSet', @sliderValChange)
            
            %Sets the value to be the current value while dragging the
            %slider
            function sliderValChange(src, event)
                
                if event.EventName == 'PostSet' 
                    %Find the setting in the node's settings and update it
                    %there. Not possible to update it through
                    %obj.value because this is a separate "workspace" where
                    %the class seems copied
                    
                    obj.node.settings{1}.value = get(event.AffectedObject, 'Value');
                end
            end
            
        end
        
        function obj = setValue(obj, value)
            obj.value = value;
            return
        end
        
        
        function hide(obj)
            
            %Delete the annotations for the setting
            if ~(isempty(obj.labelAnno))
                delete(obj.labelAnno);
                
            end
            
            if ~(isempty(obj.sliderAnno))
                delete(obj.sliderAnno);
            end
        end
        
    end   
    
end