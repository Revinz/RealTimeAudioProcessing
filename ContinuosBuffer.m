classdef ContinuosBuffer
    %Technically it is a queue buffer
    properties
        defaultBufferSize; %baseline value for the total buffer size calculation
        bufferSizeMultiplier = 60;
        totalBufferSize;
        previousBuffer = [];
    end
    
    methods
        function obj = ContinuosBuffer()
            global frameLength;
            obj.defaultBufferSize = 1024; %Baseline
            obj.totalBufferSize = 1024 * obj.bufferSizeMultiplier;
            obj.previousBuffer = zeros(obj.totalBufferSize - frameLength, 1);
        end
        
        function updatedBuffer = updatePreviousBuffer(obj, buffer)
            %Cycle the buffer with the new input buffer
            global frameLength;
            updatedBuffer = [obj.previousBuffer(frameLength+1:end); buffer];
        end

        function concatBuffer = concatBuffers(obj, buffer)
            %Used for pplying the effect on the entire buffer incl old
            %buffers to prevent popcorn sound
            concatBuffer = [obj.previousBuffer; buffer];
        end
    end
end

