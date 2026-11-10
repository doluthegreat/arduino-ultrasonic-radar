[README.md](https://github.com/user-attachments/files/34605782/README.md)
# Arduino Ultrasonic Radar

A simple ultrasonic radar demonstrator built with an Arduino Uno, an HC-SR04 ultrasonic distance sensor, an SG90 servo motor, and a Processing desktop visualization.

The servo sweeps the ultrasonic sensor across a 180-degree field of view. The Arduino measures distance at each angle and streams the readings over USB serial. Processing receives the measurements and displays a radar-style visualization.

## Hardware

- Arduino Uno
- HC-SR04 ultrasonic distance sensor
- SG90 (or compatible) servo motor
- Breadboard and jumper wires
- USB cable for the Arduino
- Optional: separate regulated 5 V supply for the servo

## Wiring

| Component | Pin | Arduino Uno |
|---|---|---|
| HC-SR04 | VCC | 5V |
| HC-SR04 | GND | GND |
| HC-SR04 | TRIG | D9 |
| HC-SR04 | ECHO | D10 |
| Servo | Signal (orange/yellow) | D11 |
| Servo | VCC (red) | 5V or external regulated 5V |
| Servo | GND (brown/black) | GND |

**Power note:** A servo can draw more current than the Arduino's USB supply can comfortably provide. If the Uno resets, the servo jitters, or readings become unreliable, power the servo from a separate regulated 5 V supply. Connect the external supply ground to Arduino GND. Do not connect an external supply's positive output to the Arduino 5V pin while also powering it through USB unless you understand the board's power arrangement.

## Software

- Arduino IDE
- Processing 3.5.4 (the project was prepared for the Processing 3 Serial library)

## Setup

### 1. Upload the Arduino firmware

1. Open `arduino/radar_controller.ino` in Arduino IDE.
2. Select **Tools → Board → Arduino Uno**.
3. Select the Uno's USB serial port under **Tools → Port**.
4. Upload the sketch.

The Arduino sends readings in this format:

```text
angle*distance#
```

For example:

```text
90*23#
```

### 2. Configure and run the Processing visualizer

1. Open the `processing` folder as a Processing sketch, or open `radar_visualizer.pde`.
2. In Processing, check **Sketch → Import Library** for **Serial**.
3. Run the sketch once with the Arduino connected to see the available serial ports in the console.
4. Update `portName` in `radar_visualizer.pde` to match the Arduino port on your Mac or computer.

For example, on one Mac setup the port was:

```java
String portName = "/dev/cu.usbmodem141011";
```

Your port name will likely be different. On macOS, it commonly starts with `/dev/cu.usbmodem`. On Windows it may look like `COM3`; on Linux it may look like `/dev/ttyACM0`.

5. Close Arduino IDE's Serial Monitor before running Processing. Only one application can normally use the serial port at a time.
6. Press **Run** in Processing.

## How it works

1. The servo moves the HC-SR04 through angles from 0 to 180 degrees.
2. At each angle, the Arduino triggers the ultrasonic sensor.
3. The sensor's echo pulse duration is converted to an approximate distance in centimetres.
4. The Arduino sends the angle and distance to the computer over serial at 9600 baud.
5. Processing parses each reading and updates the radar sweep and object marker.

## Limitations

- This is an educational proximity-detection demonstration, not a calibrated measurement instrument.
- HC-SR04 readings depend on target size, angle, surface, and environmental conditions.
- The visualization currently highlights objects within 40 cm.
- A missed echo is represented as 400 cm.
- The servo's mechanical range and mounting may not correspond exactly to a calibrated 180-degree field of view.

## Troubleshooting

**Processing says it cannot open the serial port**
- Confirm the port name matches the Arduino's port.
- Close Arduino IDE Serial Monitor.
- Disconnect and reconnect the Uno, then check the port list again.

**The radar window appears but does not update**
- Confirm the Arduino sketch has been uploaded.
- Confirm the baud rate is 9600 in both sketches.
- Confirm the serial port is correct.

**The Arduino resets or the servo jitters**
- Use a separate regulated 5 V supply for the servo.
- Connect the external supply ground and Arduino GND together.

## Project structure

```text
arduino-ultrasonic-radar/
├── arduino/
│   └── radar_controller.ino
├── processing/
│   └── radar_visualizer.pde
├── .gitignore
└── README.md
```

## Credits

This project is an implementation based on the Arduino ultrasonic radar concept. Original inspiration: [Radar System Using Ultrasonic Sensor & Arduino Uno](https://www.hackster.io/Shubham_Desai/radar-system-using-ultrasonic-sensor-arduino-uno-b855a9).

## License

MIT License. See `LICENSE` if you choose to add one before publishing.
