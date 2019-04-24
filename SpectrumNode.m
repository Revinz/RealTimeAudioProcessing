classdef SpectrumNode < Node   
    
    properties
        wavePlot;
    end
    methods
        
        function obj = SpectrumNode(pos,name,fcn)
            obj = obj@Node(pos,name,fcn);
            
            
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
            
            obj.settings{end+1} = obj.newSetting('Amplitude', 0, -1, 1, 1);
        end
        
        function drag(obj)
            drag@Node(obj);
            
       
                      
            % Set the position of the buffer -- It is x, y and then the
            % width and height
            % Insert variables in the []
            % Also add scaling the min/max values to be shown in the window
            % Lastly, limit the plot's x-length to be the same as the
            % buffer's length
           
            
            %ylim([-x x])
            %xlim([0 buffer])
            if ~isempty(obj.wavePlot)
                ylim([-0.8 0.8])
                disp(obj.wavePlot.Parent)
                obj.wavePlot.Parent.Position = [obj.anno.Position(1), obj.anno.Position(2), 0.2, 0.1];
            end
            
            % Update the position variables of the spectrum window here
        end
         
       
       
        
        function applyEffect(obj, buffer)
            % Plot the buffer
            obj.wavePlot = plot(buffer);
            
            
            
       
                      
            % Set the position of the buffer -- It is x, y and then the
            % width and height
            % Insert variables in the []
            % Also add scaling the min/max values to be shown in the window
            % Lastly, limit the plot's x-length to be the same as the
            % buffer's length
           
            ylim([-0.8 0.8]) % this needs to be interchangeable by the user
           
            
                set(gca, 'Units', 'Normalized', 'Position', [obj.anno.Position(1), obj.anno.Position(2), 0.2, 0.1])
            
            
            % Pass the buffer to the next node
            obj.passToNextNode(buffer);
            
        end
        
      
       function hideSpectrum(obj)
            %Delete the annotations for the setting
            delete(obj.wavePlot);
            %setting.sliderAnno.Visible = 'off';
       end
        
    end
end