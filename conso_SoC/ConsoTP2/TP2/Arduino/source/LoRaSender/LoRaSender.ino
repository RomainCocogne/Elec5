#include <SPI.h>
#include <LoRa.h>
#include <avr/sleep.h>
#include <avr/interrupt.h>

#define LORA_KEY "QR_pkg-"

#define DEBUG

const uint16_t angle_delta = 200;

int JoyStick_X = A0; // Signal de l'angle
int counter = 0;

uint16_t x, prev_x;
uint16_t x_center;

void setup() {
#ifdef DEBUG
  Serial.begin(9600);
  while (!Serial);
  Serial.println("LoRa Sender");
#endif

  pinMode (JoyStick_X,INPUT);

  if (!LoRa.begin(866E6)) {
#ifdef DEBUG
    Serial.println("Starting LoRa failed!");
#endif
    while (1);
  }
  LoRa.setTxPower(1,1);
  LoRa.setSpreadingFactor(7);
  LoRa.setPreambleLength(8); 

  // x calibration
  delay(10);
  x_center =  x = analogRead(JoyStick_X);
}

void loop() {
  
  x = analogRead(JoyStick_X);
  
#ifdef DEBUG
  if(abs(prev_x-x) > 1){
    Serial.print("X :"); Serial.print(x); 
  }
#endif
    // send packet
    if (angle_threshold_reached(x))
      loRa_send_onedata(x);
    prev_x=x;
    counter++;
  delay(1000);
  
}

bool angle_threshold_reached (uint16_t x){
  return abs(x-x_center) > angle_delta;
}

void loRa_send_onedata(uint16_t x, uint16_t y, int8_t b){
  LoRa.beginPacket();
    LoRa.print(LORA_KEY);
    LoRa.print(x);
    LoRa.print(";");
    LoRa.endPacket();
}
