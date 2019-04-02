classdef SpectrumNode < Node       
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
         
        end
        
        function drag(obj)
            drag@Node(obj);
            
            % Update the position variables of the spectrum window here
        end
                      
        function applyEffect(obj, buffer)
            % Plot the buffer
            plot(buffer);
            
            % Set the position of the buffer -- It is x, y and then the
            % width and height
            % Insert variables in the []
            % Also add scaling the min/max values to be shown in the window
            % Lastly, limit the plot's x-length to be the same as the
            % buffer's length
            set(gca, 'Units', 'Normalized', 'Position', [0.4, 0.4, 0.5, 0.5])
            
            
            % Pass the buffer to the next node
            obj.passToNextNode(buffer);
            
        end
    end
end