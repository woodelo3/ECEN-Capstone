
#include "SoftwareSerial.h"
float hif = 0.0;
SoftwareSerial XBee(16,17);
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
String c = "";
String final = "";
String c2 ="";
String c3 ="";
DHT dht(DHTPIN, DHTTYPE);
const int sensorLight = 13;
const int sensorSoil = 12;
//const int sensorRain = 3;
int digitalRain = 0;
void setup() {
  Serial.begin(115200);
  XBee.begin(9600);
  Serial.println(F("DHT22 Data"));

  dht.begin();
}

void loop() {
  // Wait a few seconds between measurements.
  delay(5000);
  

  float h = dht.readHumidity();
  // Read temperature as Celsius (the default)
  float t = dht.readTemperature();
  // Read temperature as Fahrenheit (isFahrenheit = true)
  float f = dht.readTemperature(true);

  // Check if any reads failed and exit early (to try again).
  if (isnan(h) || isnan(t) || isnan(f)) {
    Serial.println(F("Failed to read from DHT sensor!"));
    return;
  }

  // Compute heat index in Fahrenheit (the default)
  hif = 0.0;
  hif = dht.computeHeatIndex(f, h);
  // Compute heat index in Celsius (isFahreheit = false)
  float hic = dht.computeHeatIndex(t, h, false);
  c = "";
  c2 = "";
  c2.concat(h);
  c.concat(hif);
  Serial.print(F("Humidity: "));
  Serial.print(h);
  Serial.print(F("%  Temperature: "));
  Serial.print(t);
  Serial.print(F("°C "));
  Serial.print(f);
  Serial.print(F("°F  Heat index: "));
  Serial.print(hic);
  Serial.print(F("°C "));
  Serial.print(hif);
  Serial.println(F("°F"));
  
  int analogLight = analogRead(sensorLight);
     Serial.print("SunLight = ");
    Serial.println(analogLight);

  float analogSoil = analogRead(sensorSoil);
  Serial.println(analogSoil);
  analogSoil = 4095 - analogSoil;
  analogSoil = analogSoil / 40.95;
    Serial.print(F ("Soil Sensor Value "));
    Serial.println(analogSoil);
  Serial.println("Attempting to Send");
  c3 = "";
  String sensor = "1";
  c3.concat(analogSoil);
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
  delay(20000);
}
