
#include "SoftwareSerial.h"

float hif = 0.0;
SoftwareSerial XBee(16, 17);
/*
  void setup() {
   Serial.begin(115200);
  }

  void loop() {
   Serial.println("Hello World");
   delay(2000);
  }
*/
#include "DHT.h"
#define DHTPIN 14
#define DHTTYPE DHT22   // DHT 22  (AM2302), AM2321
String sensornum = "1";
String c = "0";
String final = "0";
String c2 = "0";
String c3 = "0";
DHT dht(DHTPIN, DHTTYPE);
const int sensorLight = 13;

int rainVal = 0;

//const int sensorRain = 3;
int digitalRain = 0;
void setup() {
  Serial.begin(115200);
  XBee.begin(9600);
  Serial.println(F("DHT22 Data"));
  pinMode(14, INPUT_PULLUP);
  dht.begin();
  attachInterrupt(digitalPinToInterrupt(14), rain, FALLING);
}
void rain (void) {
  rainVal= rainVal+1;
}

void loop() {
  delay(5000);
  Serial.println("Rain Value");
  rainVal = rainVal / 10;
  Serial.println(rainVal);
  Serial.println("Attempting to Send");
  c3 = "0";
  String sensor = "3";
  c3.concat(rainVal);
  //XBee.write("2");
  //Serial.println("2");
  //delay(1000);
  const char* send1 = c.c_str();
  // XBee.write(send1);
  // Serial.println(send1);
  //delay(1000);
  const char* send2 = c2.c_str();
  // XBee.write(send2);
  // Serial.println(send2);
  // delay(1000);
  const char* send3 = c3.c_str();
  //XBee.write(send3);
  //Serial.println(send3);
  final = sensor + "-" + c + "-" + c2 + "-" + c3;
  const char*send = final.c_str();
  XBee.write(send);
  Serial.println(send);
  rainVal = 0;
  delay(10000);
}
