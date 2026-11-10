import processing.serial.*;

Serial port;

int radarAngle = 90;
int radarDistance = 400;

final int MAX_DISTANCE_CM = 40;
final float PIXELS_PER_CM = 11.0;

void setup() {
  size(1000, 600);
  smooth();

  println("Available serial ports:");
  printArray(Serial.list());

  // Update this if your Arduino appears on a different port.
  String portName = "/dev/cu.usbmodem141011";

  port = new Serial(this, portName, 9600);
  port.clear();
  port.bufferUntil('#');
}

void draw() {
  background(0);

  // Draw the radar with its origin at the bottom centre.
  pushMatrix();
  translate(width / 2, height - 40);

  stroke(0, 255, 0);
  strokeWeight(2);
  noFill();

  for (int r = 1; r <= 4; r++) {
    arc(0, 0, r * 220, r * 220, PI, TWO_PI);
  }

  line(-440, 0, 440, 0);

  for (int angle = 30; angle <= 150; angle += 30) {
    float x = 440 * cos(radians(angle));
    float y = -440 * sin(radians(angle));
    line(0, 0, x, y);
  }

  // Scanning line
  stroke(0, 255, 0);
  strokeWeight(3);
  float scanX = 440 * cos(radians(radarAngle));
  float scanY = -440 * sin(radians(radarAngle));
  line(0, 0, scanX, scanY);

  // Detected object
  if (radarDistance > 0 && radarDistance <= MAX_DISTANCE_CM) {
    float radius = radarDistance * PIXELS_PER_CM;
    float objectX = radius * cos(radians(radarAngle));
    float objectY = -radius * sin(radians(radarAngle));

    stroke(255, 0, 0);
    strokeWeight(9);
    point(objectX, objectY);
  }

  popMatrix();

  // Status panel
  fill(0, 255, 0);
  textSize(18);
  text("ARDUINO ULTRASONIC RADAR", 20, 30);
  text("Angle: " + radarAngle + " degrees", 20, 60);
  text("Distance: " + radarDistance + " cm", 20, 90);

  if (radarDistance > 0 && radarDistance <= MAX_DISTANCE_CM) {
    fill(255, 70, 70);
    text("OBJECT DETECTED", 20, 125);
  } else {
    fill(0, 255, 0);
    text("AREA CLEAR", 20, 125);
  }
}

// Arduino sends each reading as: angle*distance#
void serialEvent(Serial incomingPort) {
  String message = incomingPort.readStringUntil('#');

  if (message == null) {
    return;
  }

  message = trim(message);
  message = message.substring(0, message.length() - 1);

  String[] values = split(message, '*');

  if (values.length == 2) {
    try {
      int newAngle = int(values[0]);
      int newDistance = int(values[1]);

      if (newAngle >= 0 && newAngle <= 180 &&
          newDistance >= 0 && newDistance <= 400) {
        radarAngle = newAngle;
        radarDistance = newDistance;
      }
    }
    catch (Exception e) {
      println("Ignoring invalid serial reading: " + message);
    }
  }
}
