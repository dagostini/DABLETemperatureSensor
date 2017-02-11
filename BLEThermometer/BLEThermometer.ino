#include <SPI.h>
#include "Adafruit_BLE_UART.h"

#define ADAFRUITBLE_REQ 10
#define ADAFRUITBLE_RDY 2
#define ADAFRUITBLE_RST 9

Adafruit_BLE_UART BTLEserial = Adafruit_BLE_UART(ADAFRUITBLE_REQ, ADAFRUITBLE_RDY, ADAFRUITBLE_RST);

const int numReadings = 50;
const int initialValue = 144;

int readings[numReadings];
int readIndex = 0;
int total = initialValue * numReadings;

const int sensorPin = A0;

void setup() {
  Serial.begin(9600);

  for (int thisReading = 0; thisReading < numReadings; thisReading++) {
    readings[thisReading] = initialValue;
  }
  
  BTLEserial.setDeviceName("BLETemp");
  BTLEserial.begin();
}

aci_evt_opcode_t laststatus = ACI_EVT_DISCONNECTED;

void loop() {
  BTLEserial.pollACI();

  aci_evt_opcode_t status = BTLEserial.getState();
  if (status != laststatus) {
    laststatus = status;
  }

  if (status == ACI_EVT_CONNECTED) {
    String temperatureString = averageTemperature();
    
    uint8_t sendbuffer[20];
    temperatureString.getBytes(sendbuffer, 20);
    char sendbuffersize = min(20, temperatureString.length());

    Serial.print(F("\n* Sending -> \"")); Serial.print((char *)sendbuffer); Serial.println("\"");

    BTLEserial.write(sendbuffer, sendbuffersize);
  }
}

String averageTemperature() {
  int average = averageValue(sensorPin);
  return temperature(average);
}

int averageValue(int inputPin) {
  total = total - readings[readIndex];
  readings[readIndex] = analogRead(inputPin);
  total = total + readings[readIndex];
  readIndex = readIndex + 1;

  if (readIndex >= numReadings) {
    readIndex = 0;
  }
  
  return total / numReadings;
}

String temperature(int sensorVal) {
  float voltage = (sensorVal / 1024.0) * 5.0;
  float temperature = (voltage - .5) * 100;
  Serial.println(temperature);
  return String(temperature);
}

