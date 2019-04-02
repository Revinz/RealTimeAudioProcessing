classdef HighpassNode < Node  
    
    properties
        cutoffHz = 200;
    end
    methods
           
        function obj = HighpassNode(pos,name,fcn)
            obj = obj@Node(pos,name,fcn);
            
            
            % The settings
            obj.settings{end + 1} = obj.newSetting('cutoff', 200); %1

        end
        
        function applyEffect(obj, buffer)
            global Fs;
            
            %Make the filter -- LOOK UP WHAT THE PROPERTIES MEANS!
            if ~(obj.settings{1}.value == 0)
                fc = obj.settings{1}.value; %Cutoff Frequency
                Wn = (2/Fs)*fc;
                b = fir1(20,Wn,'high',kaiser(21,3));

                wetBuffer = filter(b,1,buffer);
                obj.passToNextNode(wetBuffer);
          
            end
            
            %If Hz = 0, just pass the buffer to the next node without
            %filtering
            obj.passToNextNode(buffer);
            
            
        end
    end
end