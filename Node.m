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
        prevNode;

        %All the available settings for the node
        settings = {};
        settingsOpened = false;
        settingsBgAnno;
        
    end
    methods
        function  obj = Node(pos,name,fcn)
            obj.anno = annotation('textbox','Position',pos,'String',name,'ButtonDownFcn',fcn);
            obj.Name = name;
            obj.Function = fcn;

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
                
                obj.delButton.anno.Position(1) = obj.anno.Position(1)+obj.anno.Position(3)/2.7;
                obj.delButton.anno.Position(2) = obj.anno.Position(2) + 0.15;
            catch
            end
        end

        function tap(obj)
            global Interactables

            if (obj.settingsOpened == false)
                if isa(obj, 'FlangerNode') || isa(obj, 'LowpassNode') || isa(obj, 'SpectrumNode') || isa(obj, 'HighpassNode')
                    obj.delButton = DeleteButton(obj.anno.Position, obj.Function);
                    Interactables{end+1} = obj.delButton;
                end
                disp('Settings Opened')
                obj.openSettings();
            elseif (obj.settingsOpened == true)
                if isa(obj, 'FlangerNode') || isa(obj, 'LowpassNode') || isa(obj, 'SpectrumNode') || isa(obj, 'HighpassNode')
                    delete(obj.delButton.anno);
                    delete(obj.delButton);
                    Interactables(end) = [];
                end
                disp('Settings Closed')
                obj.closeSettings();
            end 
        end

        
        function pressDelete(obj,selectedObject)
            if selectedObject == obj.delButton
                obj.closeSettings();
                obj.delButton.removeNode(obj);
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
            
            %Only open settings if there are any
            if ~(isempty(obj.settings))
                
                obj.anno.BackgroundColor = 'k';
                obj.anno.FaceAlpha = 0.2;
                obj.settingsBgAnno = annotation('textbox');

                lowestPos = (length(obj.settings)* 0.11) - 0.05;
                for i = length(obj.settings):-1:1 %Go in reverse order since we start from the bottom and goes up
                    y1Pos = (i * 0.11) - 0.05; %Just pass where the lower left corner is
                    obj.settings{i}.draw(y1Pos);
                end
                obj.settingsBgAnno.BackgroundColor = 'k';
                obj.settingsBgAnno.FaceAlpha = 0.2;
                updateSettingsBgPos(obj) 
                
                
                
                obj.settingsOpened = true;
                disp(obj.settingsOpened)
            end           
        end
        

        
        function nodeDelete(obj)
            global Interactables
            if isa(obj, 'FlangerNode') || isa(obj, 'LowpassNode')
                delete(obj.anno);
                for i = 1:length(Interactables)
                    try
                        if Interactables{i}.anno == obj.anno
                            Interactables{i} = [];
                            Interactables{i-1} = [];
                            Interactables{i-2} = [];
                        end
                    catch
                    end
                end
                delete(obj.inSocket.anno);
                delete(obj.outSocket.anno);
                delete(obj.inSocket);
                delete(obj.outSocket);
                delete(obj);
            end
            
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
            
            obj.anno.BackgroundColor = 'none';
            obj.anno.FaceAlpha = 0;
            
            if ~(isempty(obj.settings))              
                for i = 1:length(obj.settings)
                    obj.settings{i}.hide(obj.settings{i});
                end
                obj.settingsOpened = false;
            end
            
            delete(obj.settingsBgAnno)
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
            end

            return;
        end
        
    end
    
    
    
     methods (Abstract)
         applyEffect(obj, buffer);
     end
end