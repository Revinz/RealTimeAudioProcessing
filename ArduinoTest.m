clear a;
global a;
a = arduino('COM12', 'uno');

for j = 1:100 
analogButton = readVoltage(a,'A1') * (1023 / 5);
analogKnob = readVoltage(a,'A5');
disp(analogKnob);

if analogButton > 500
    writeDigitalPin(a, 'A3', 1);
    
else
    writeDigitalPin(a, 'A3', 0);
end
pause(0.5);
end