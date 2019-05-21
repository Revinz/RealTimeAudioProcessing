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
        dragging = false;
        
        Function;
        delButton;
        delButtonOffset = 0.17;
        prevNode;

        %All the available settings for the node
        settings = {};
        settingsOpened = false;
        settingsBgAnno;
        
        %Colors used
        selectedColor = [0.68,0.81,0.88];
        normalColor = [0.62,0.75,0.76];
        
        %The continuous buffer, used to prevent popcorn sounds
        contBuffer;
    end
    methods
        function  obj = Node(pos,name,fcn)
            obj.anno = annotation('textbox','Position',pos,'String',name,'ButtonDownFcn',fcn,'LineWidth',0.55);
            obj.Name = name;
            obj.contBuffer = ContinuosBuffer();
            obj.Function = fcn;
            obj.anno.BackgroundColor = obj.normalColor; 
           
        end
                
        function select(obj)
            obj.orPos = get(gcf,'CurrentPoint');
            obj.prevNode = obj;
            
        end

        function drop(obj)
            newPos = get(gcf,'CurrentPoint');
            posDiff = newPos - obj.orPos;
            

            set(obj.anno,'Position',get(obj.anno,'Position') + [posDiff(1:2) 0 0]);
            updateSocketPositions(obj);
            
            %Tapped if the person didn't drag
            if (obj.dragging == false)
                obj.tap();
            end
            try
            obj.dragging = false;
            catch
            end
        end

        function drag(obj)
            obj.dragging = true;
            newPos = get(gcf,'CurrentPoint');
            try
                posDiff = newPos - obj.orPos;

                obj.orPos = newPos;
                set(obj.anno,'Position',get(obj.anno,'Position') + [posDiff(1:2) 0 0]);
                updateSocketPositions(obj);
                updateSettingsPos(obj);
                
                obj.updateDelButtonPos();
            catch
            end
        end

        function tap(obj)
            global Interactables

            if (obj.settingsOpened == false)
                disp('Settings Opened')
                obj.openSettings();
            elseif (obj.settingsOpened == true)
                disp('Settings Closed')
                obj.closeSettings();
            end 
        end

        
        function pressDelete(obj)
            %if selectedObject == obj.delButton
                obj.closeSettings();    
                obj.delButton.removeNode(obj);
            %end
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
        
        function updateConnectionLines(obj)
            %Update the connectionLine from the inSocket
            if ~isempty(obj.inSocket)
                
                if ~isempty(obj.inSocket.connectionLine) && isvalid(obj.inSocket.connectionLine)
                    
                    % Formula: inSocket position of the node 
                    % + socket offset
                    % - startPos of the connection line
                    obj.inSocket.connectionLine.Position(3) = (obj.inSocket.anno.Position(1)+obj.inSocket.socketOffset(1)-obj.inSocket.connectionLine.Position(1));
                    obj.inSocket.connectionLine.Position(4) = (obj.inSocket.anno.Position(2)+obj.inSocket.socketOffset(2)-obj.inSocket.connectionLine.Position(2));
                end
            end
            %Update the connectionLine from the outSocket
            if ~isempty(obj.outSocket)
                if ~isempty(obj.outSocket.connectionLine) && isvalid(obj.outSocket.connectionLine)
                    
                    changeInPos = [obj.outSocket.connectionLine.Position(1) obj.outSocket.connectionLine.Position(2)];
                    obj.outSocket.connectionLine.Position(1) = (obj.outSocket.anno.Position(1)+obj.outSocket.socketOffset(1));
                    obj.outSocket.connectionLine.Position(2) = (obj.outSocket.anno.Position(2)+obj.outSocket.socketOffset(2));
                    changeInPos(1) = changeInPos(1) - obj.outSocket.connectionLine.Position(1);
                    changeInPos(2) = changeInPos(2) - obj.outSocket.connectionLine.Position(2);
                    obj.outSocket.connectionLine.Position(3) =  obj.outSocket.connectionLine.Position(3) + changeInPos(1);
                    obj.outSocket.connectionLine.Position(4) = obj.outSocket.connectionLine.Position(4) + changeInPos(2);
                end
            end            

        end
        
        function passToNextNode(obj, buffer)
            
            if ~isempty(obj.outSocket.nextNode)
                try
                    obj.outSocket.nextNode.applyEffect(buffer);
                catch                   
                end
            end
        end  
        
        function openSettings(obj)
            global Interactables;
            obj.anno.BackgroundColor = obj.selectedColor; 
            
            %Only open settings if there are any
            if ~(isempty(obj.settings))
                
                if isa(obj, 'FlangerNode') || isa(obj, 'LowpassNode') || isa(obj, 'SpectrumNode') || isa(obj, 'HighpassNode') || isa(obj, 'DelayNode') || isa(obj, 'ReverbNode')
                    obj.delButton = DeleteButton([obj.anno.Position (obj.getLowestPos() - 0.2)], obj.Function, obj);
                    %Update the position right away, since it doesn't spawn
                    %at the correct position
                    obj.updateDelButtonPos();
                    Interactables{end+1} = obj.delButton;
                    obj.delButton
                end
                
                obj.settingsBgAnno = annotation('textbox');

                
                for i = length(obj.settings):-1:1 %Go in reverse order since we start from the bottom and goes up
                    y1Pos = (i * 0.11) - 0.05; %Just pass where the lower left corner is for the setting
                    obj.settings{i}.draw(y1Pos);
                end
                obj.settingsBgAnno.BackgroundColor = obj.selectedColor;
                updateSettingsBgPos(obj) 
                
                
                
                obj.settingsOpened = true;
                disp(obj.settingsOpened)
            end           
        end
        
        function updateDelButtonPos(obj)
            
            obj.delButton.axes.Position(1) = obj.anno.Position(1)+obj.anno.Position(3)/2.7;
            obj.delButton.axes.Position(2) = obj.getLowestPos() - obj.delButtonOffset;
            
            obj.delButton.anno.Position(1) = obj.anno.Position(1)+obj.anno.Position(3)/2.7;
            obj.delButton.anno.Position(2) = obj.getLowestPos() - obj.delButtonOffset;
        end
   
        %Returns the lowest position when the settings are opened
        function lowestPos = getLowestPos(obj) 
            lowestPos = obj.anno.Position(2) - ((length(obj.settings)* 0.11) - 0.05);
        end
        
        
        function updateSettingsPos(obj) 
            updateSettingsBgPos(obj) 
            
            for i = length(obj.settings):-1:1 %Go in reverse order since we start from the bottom and goes up
                y1Pos = (i * 0.11) - 0.05; %Just pass where the lower left corner is
                obj.settings{i}.updatePos(obj.settings{i}, obj, y1Pos);
            end
        end
        
        function updateSettingsBgPos(obj) 
            
            bottomPos = (length(obj.settings) * 0.11) - 0.05;
            obj.settingsBgAnno.Position(1) = obj.anno.Position(1) - 0.03;
            obj.settingsBgAnno.Position(2) = obj.anno.Position(2) - bottomPos - 0.06;
            obj.settingsBgAnno.Position(3) = obj.anno.Position(3) + 0.06;
            obj.settingsBgAnno.Position(4) = bottomPos + 0.06;           
        end
        
        function closeSettings(obj)
            if isa(obj, 'FlangerNode') || isa(obj, 'LowpassNode') || isa(obj, 'SpectrumNode') || isa(obj, 'HighpassNode') || isa(obj, 'DelayNode') || isa(obj, 'ReverbNode')
                    if ~isempty(obj.delButton)
                        obj.delButton.removeButton();
                    end
            end
            
            obj.anno.BackgroundColor = obj.normalColor;
            
            if ~(isempty(obj.settings))              
                for i = 1:length(obj.settings)
                    obj.settings{i}.hide(obj.settings{i});
                end
                obj.settingsOpened = false;
            end
            
            if ~isempty(obj.settingsBgAnno)
                try
                    delete(obj.settingsBgAnno)
                catch
                end
                    
            end

        end
        
        %Add a new setting
        function setting = newSetting(obj, settingName, default)
            switch (settingName)
                case 'vol'
                    setting = Setting('Volume', default, 0, 1, 0.01, obj);
                case 'wetdry'
                    setting = Setting('Wet Dry Mix', default, 0, 1, 0.01, obj);
                case 'delay'
                    setting = Setting('Delay (ms)', default, 0, 30, 0.01, obj);
                case 'rate'
                    setting = Setting('Rate (Hz)', default, 0, 1, 0.01, obj);
                case 'cutoff'
                    setting = Setting('Cutoff Frequency', default, 1, 5000, 50, obj);
                case 'feedback'
                    setting = Setting('feedback', default, 0, 1, 0.01, obj);
                case 'depth'
                    setting = Setting('Depth', default, 0, 80, 1, obj);
                case 'noteDelay' %Needs a better name!
                    setting = Setting('Delay (whole notes)', default, 0, 1, 0.25, obj);
                case 'bpm'
                    setting = Setting('Beats per minute', default, 50, 180, 1, obj);
            end

            return;
        end
        
    end
    
    
    
     methods (Abstract)
         applyEffect(obj, buffer);
     end
end