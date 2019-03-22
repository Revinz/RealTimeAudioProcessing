a = arduino('com3', 'uno');

frameLength = 128 % How many samples

audioInput = audioDeviceReader

% start the loop to blink led for 10 seconds

for i = 1:10

    writeDigitalPin(a, 'D11', 1);

    pause(0.5);

    writeDigitalPin(a, 'D11', 0);

    pause(0.5);

end

% end communication with arduino

clear a