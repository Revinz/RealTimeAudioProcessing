classdef ArduinoPID
    
    properties
        arduino;        
        ledPin = 'D6';
    end
    
    % HOW TO ARDUINO IN MATLAB
    %   https://se.mathworks.com/help/supportpkg/arduinoio/getting-started-with-matlab-support-package-for-arduino-hardware.html
    %
    %
    % Or use the source code: run once -> right click arduino the the
    % properties list -> click 'Open 'arduino' 
    
    %Error: MATLAB connection to Arduino Uno at COM_ exists in your workspace. To create a new connection, clear the existing
    % object.
    
    % Find 'a' in the variable list (Workspace - should be on the right
    % side) -> right click -> delete.
    
    
    methods
        function obj = ArduinoPID()
            try
            obj.arduino = arduino('COM3', 'uno'); %CHANGE COM NUMBER! You can find it in the device manager
            disp('Arduino connected');
            %Setup pins
            obj.arduino.configurePin(obj.ledPin, 'DigitalOutput');
            catch
                disp('Arduino NOT connected');
            end
        end
        
        
        function loop(obj) 
            %use this one as Arduino's loop. (It is just being called in the
            %while loop in the Main.m)
            
            %Example:
            obj.turnOnLED()
            pause(0.5);
            obj.turnOffLED()
            pause(0.5);
        end
        
        % PLEASE keep the functionality inside methods
        
        % Methods used for the example -- Can be deleted.
        function turnOnLED(obj)
            obj.arduino.writeDigitalPin(obj.ledPin, 1);
        end
        
        function turnOffLED(obj)
            obj.arduino.writeDigitalPin(obj.ledPin, 0);
        end
    end
end

