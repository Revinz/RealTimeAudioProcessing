classdef InputNode < Node
    methods
        function obj = InputNode(pos,name,fcn)
            global inputDevice;
            global outputDevice;
            global Fs;
            global frameLength; 

            obj = obj@Node(pos,name,fcn); %Call parent constructor
            inputDevice = audioDeviceReader(Fs, frameLength,'BitDepth','16-bit integer');
            outputDevice = audioDeviceWriter( ...
                    'SampleRate',inputDevice.SampleRate); 
        
        end
        
        function retrieveBuffer(obj)
            global inputDevice;
            %Get the input buffer here
             dryBuffer = inputDevice();
            %Pass it on
            obj.applyEffect(dryBuffer);

            
        end     
        
        function applyEffect(obj, buffer)
            %disp(['Current Node: ', obj.Name]);
            obj.passToNextNode(buffer);
            
        end
        
        function drag(obj)
        end
        
        function drop(obj)
        end
    end
    
    
end