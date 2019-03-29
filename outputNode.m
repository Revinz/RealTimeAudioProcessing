classdef OutputNode < Node
    
    properties
        scope;
    end
    
    methods
        
        function obj = OutputNode(pos,name,fcn)
            global inputDevice;
            obj = obj@Node(pos,name,fcn);
            
            %Scope to show the output
            obj.scope = dsp.TimeScope( ...        
                'SampleRate',inputDevice.SampleRate, ... 
                'TimeSpan',0.05, ...                      
                'BufferLength',1.5e6, ...               
                'YLimits',[-0.3,0.3]); 
            
            
            % The settings
            obj.settings{end + 1} = obj.newSetting('vol', 1);
        end
        
        function playBuffer(obj, finalBuffer)
            global DEBUG;
            global outputDevice;
            global input;
            %Play the buffer
            
            finalBuffer = finalBuffer * obj.settings{1}.value;
            overrun = outputDevice(finalBuffer);         

            if DEBUG == true
                disp(["Overrun: ", overrun]);
                obj.scope(finalBuffer);
            end
           
            
        end
        
        function applyEffect(obj, buffer)
            %disp(['Current Node: ', obj.Name]);       
            obj.playBuffer(buffer);
            
        end
    end
end