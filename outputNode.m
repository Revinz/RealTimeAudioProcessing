classdef OutputNode < Node
    
    properties
        scope
    end
    
    methods
        
        function obj = OutputNode(pos,name,fcn)
            global inputDevice;
            obj = obj@Node(pos,name,fcn);
            
            
            obj.scope = dsp.TimeScope( ...        
                'SampleRate',inputDevice.SampleRate, ... 
                'TimeSpan',0.05, ...                      
                'BufferLength',1.5e6, ...               
                'YLimits',[-0.3,0.3]); 
        end
        
        function playBuffer(obj, finalBuffer)
            global DEBUG;
            global outputDevice;
            global input;
            %Play the buffer
            outputDevice(finalBuffer);         
            

            if DEBUG == true
                obj.scope(finalBuffer);
            end
           
            
        end
        
        function applyEffect(obj, buffer)
            %disp(['Current Node: ', obj.Name]);
            
            drawnow();            
            obj.playBuffer(buffer);
            
        end
    end
end