#include <Servo.h>

const byte TRIG_PIN = 9;
const byte ECHO_PIN = 10;
const byte SERVO_PIN = 11;

const unsigned long ECHO_TIMEOUT_US = 30000UL;
const int SERVO_STEP_DELAY_MS = 50;

Servo radarServo;

int measureDistanceCm() {
  digitalWrite(TRIG_PIN, LOW);
  delayMicroseconds(2);

  digitalWrite(TRIG_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG_PIN, LOW);

  unsigned long duration = pulseIn(ECHO_PIN, HIGH, ECHO_TIMEOUT_US);

  // Return 400 cm when no echo is received.
  if (duration == 0) {
    return 400;
  }

  return (int)(duration * 0.0343 / 2.0);
}

void sendReading(int angle, int distanceCm) {
  // Processing expects: angle*distance#
  Serial.print(angle);
  Serial.print('*');
  Serial.print(distanceCm);
  Serial.print('#');
}

void scanAtAngle(int angle) {
  radarServo.write(angle);
  delay(SERVO_STEP_DELAY_MS);

  int distanceCm = measureDistanceCm();
  sendReading(angle, distanceCm);
}

void setup() {
  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);

  digitalWrite(TRIG_PIN, LOW);

  radarServo.attach(SERVO_PIN);
  Serial.begin(9600);

  radarServo.write(0);
  delay(500);
}

void loop() {
  for (int angle = 0; angle <= 180; angle++) {
    scanAtAngle(angle);
  }

  for (int angle = 180; angle >= 0; angle--) {
    scanAtAngle(angle);
  }
}
