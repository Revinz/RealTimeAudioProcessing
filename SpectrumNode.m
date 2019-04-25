classdef SpectrumNode < Node   
    
    properties
        wavePlot;
        plotAxes;
    end
    methods
        
        function obj = SpectrumNode(pos,name,fcn)
            obj = obj@Node(pos,name,fcn);
            
            obj.checkForExistingAxes();
            % The settings -- Add the settings for this node below here
            % Check Node.m line 186 newSetting() to see if the settings already exist, if not,
            % add them in the that function like the rest
            
            % add new setting to the note like this:
            % obj.settings{end + 1} = obj.newSetting('wetdry', 0.5); %1
            
            % ONLY change the setting name 'wetdry' to the correct setting
            % for the switch statement and default value. Change the min,
            % max and sliderStep values in the newSetting() function inside
            % Node.m   
            
            % The settings
           
            
            obj.settings{end+1} = Setting('Amplitude',1 , 0.01, 1, 1, obj);
        end
        
        function drag(obj)
            drag@Node(obj); 
            
            
            if ~isempty(obj.wavePlot)
                ylim(obj.plotAxes, [-obj.settings{1}.value obj.settings{1}.value])
                disp(obj.wavePlot.Parent)
                obj.plotAxes.Position = [obj.anno.Position(1) - 0.025 , obj.anno.Position(2) + 0.2, 0.2, 0.1];
            end
            
            % Update the position variables of the spectrum window here
        end
         
            function applyEffect(obj, buffer)
            % Plot the buffer
            
            obj.wavePlot = plot(obj.plotAxes, buffer);  
            obj.showSpectrum();
            ylim(obj.plotAxes, [-obj.settings{1}.value obj.settings{1}.value]) % this needs to be interchangeable by the user
            
            global frameLength;
            xlim([0 frameLength]);
           
            obj.plotAxes.Position = [obj.anno.Position(1) - 0.025, obj.anno.Position(2) + 0.2, 0.2, 0.1];
            
%                 set(gca, 'Units', 'Normalized', obj.anno.Position(1), [obj.anno.Position(1), obj.anno.Position(2), 0.2, 0.1])
            
            
            % Pass the buffer to the next node
            obj.passToNextNode(buffer);
            
        end
        
      
       function hideSpectrum(obj)
            %Delete the annotations for the setting
            obj.plotAxes.Visible = 'off'; %Hides the plot axes
            obj.wavePlot.Visible = 'off'; %Hides the line
            %delete(obj.wavePlot);
            %setting.sliderAnno.Visible = 'off';
       end
       
       function showSpectrum(obj)
           obj.plotAxes.Visible = 'on';
           obj.wavePlot.Visible = 'on';
       end
       
       function checkForExistingAxes(obj)
           if isempty(obj.plotAxes)
                obj.plotAxes = axes('Visible', 'off');
           end
       end
    end
end