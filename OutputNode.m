classdef OutputNode < Node
    
    properties
        scope;
        volume = 1;
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
        end
        
        function playBuffer(obj, finalBuffer)
            global DEBUG;
            global outputDevice;
            global input;
            %Play the buffer
            
            finalBuffer = finalBuffer * obj.volume;
            overrun = outputDevice(finalBuffer);         

            if DEBUG == true
                disp(["Overrun: ", overrun]);
                obj.scope(finalBuffer);
                waveform = plot(finalBuffer);
                set(gca, 'Units', 'Normalized', 'Position', [0.4, 0.4, 0.5, 0.5])
            end
           
            
        end
        
        function applyEffect(obj, buffer)
            %disp(['Current Node: ', obj.Name]);       
            obj.playBuffer(buffer);
            
        end
        
        function drag(obj)
        end
        
               
        function drop(obj)
        end
        
    end
end
