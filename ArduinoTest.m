clear a;

a = arduino('COM3', 'uno');
a.configurePin('D5', 'DigitalOutput');
a.writeDigitalPin('D5', 1);