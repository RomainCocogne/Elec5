#define LORA_KEY "QR_pkg-"

#define DEBUG

int counter = 0;

void setup() {

  Serial.begin(9600);
  Serial.println("LoRa Sender");

  
}

void loop() {
  Serial.print("Packet received : ");
  Serial.println(counter);
  counter++;
  delay(1000);
  
}
