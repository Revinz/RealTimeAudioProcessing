classdef ArduinoPID
    
    properties
        arduino;        
        sensorPin = 'A1';
        
        %Hysterisis thresholds for when the button is being clicked /
        %released
        hysON = 235;
        hysOFF = 100;
        bnDown = false; %Is the button down or not
        
        % Button LED pins
        LED1 = "D5";
        LED2 = "D6";
        LED_OFF_BRIGHTNESS = 0.2;
        LED_ON_BRIGHTNESS = 1;
        
        
        %Knob
        knobPin = "A5";
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
            obj.arduino = arduino('COM4', 'uno'); %CHANGE COM NUMBER! You can find it in the device manager
            disp('Arduino connected');
            
            %Setup pins
            obj.arduino.configurePin(obj.sensorPin, 'AnalogInput');
            obj.arduino.configurePin(obj.knobPin, 'AnalogInput');
            obj.arduino.configurePin(obj.LED1, 'AnalogOutput');  
            obj.arduino.configurePin(obj.LED2, 'AnalogOutput');
            
            
            catch
                disp('Arduino NOT connected');
            end
        end
        
        
        function obj = loop(obj) 
            %use this one as Arduino's loop. (It is just being called in the
            %while loop in the Main.m)
            
            %Turn on the LEDs at their 'off' brightness
            writePWMDutyCycle(obj.arduino, obj.LED1, obj.LED_OFF_BRIGHTNESS);
            writePWMDutyCycle(obj.arduino, obj.LED2, obj.LED_OFF_BRIGHTNESS);
            
            %Read Sensor
            SensorVal = obj.arduino.readVoltage("A1") * (1024 / 5); %Read and convert it into a scale from 0 - 1024
            %disp(SensorVal)
            
            %Hysterisis on the sensor value
            if (SensorVal >= obj.hysON && obj.bnDown == false)
                obj.bnDown = true;
                obj.ClearAll();
            elseif (SensorVal <= obj.hysOFF && obj.bnDown == true)
                obj.bnDown = false;
                disp("RELEASED")
            end
            
            
            %Read knob value and adjust volume
            obj.AdjustVolume();
        end
        
        % PLEASE keep the functionality inside methods
        
        function ClearAll(obj)
            global Interactables
            disp("CLICKED")
                 
            % Delete all effect nodes on the UI
            index = 1;
            while index <= length(Interactables)
                    if isa(Interactables{index}, 'Node')
                        if ~isa(Interactables{index}, 'InputNode') && ~isa(Interactables{index}, 'OutputNode')
                            
                            %Turn on the LED's on the first node to be
                            %deleted has been found
                            writePWMDutyCycle(obj.arduino, obj.LED1, obj.LED_ON_BRIGHTNESS);
                            writePWMDutyCycle(obj.arduino, obj.LED2, obj.LED_ON_BRIGHTNESS);
                           
                            %Delete the node
                           if Interactables{index}.settingsOpened == false %Open the settings first to delete the node
                                Interactables{index}.openSettings();
                                Interactables{index}.pressDelete();
                           else 
                               Interactables{index}.pressDelete();
                           end
                           index = 1; %Recheck since the cell array list gets updated and reduced in size. Also prevents out-of-index error.
                        end
                    end
                    
                    index = index + 1; %Check the next object
            end
            
            %Lower the brightness of the LEDs again.
            writePWMDutyCycle(obj.arduino, obj.LED1, obj.LED_OFF_BRIGHTNESS);
            writePWMDutyCycle(obj.arduino, obj.LED2, obj.LED_OFF_BRIGHTNESS);


        end
        
        function AdjustVolume(obj)
            global output;
            analogKnob = readVoltage(obj.arduino,obj.knobPin);
            disp(analogKnob)
            output.volume = analogKnob / 5;
             
        end
        
    end
end

