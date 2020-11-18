#include <SPI.h>
#include <LoRa.h>

#define LORA_KEY_SIZE 7
#define LORA_KEY "QR_pkg-"

void setup() {
  Serial.begin(9600);
  while (!Serial);

  Serial.println("LoRa Receiver");

  if (!LoRa.begin(866E6)) {
    Serial.println("Starting LoRa failed!");
    while (1);
  }
  LoRa.setSpreadingFactor(7);
  LoRa.setPreambleLength(8); 
}

void loop() {
  // try to parse packet
  int packetSize = LoRa.parsePacket();
  if (packetSize) {

    String read_data;
    while (LoRa.available()) {
      read_data +=(char)LoRa.read();
    }
    if(read_data.substring(0,LORA_KEY_SIZE) == LORA_KEY){
      Serial.print(read_data.substring(LORA_KEY_SIZE));
    }
  }
}
