#include<SoftwareSerial.h>
#include <WiFi.h>                  // Use this for WiFi instead of Ethernet.h
#include <MySQL_Connection.h>
#include <MySQL_Cursor.h>
#include <ESPDateTime.h>
#define TZ_America_Mexico_City  PSTR("CST6CDT,M4.1.0,M10.5.0")
byte mac_addr[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
String c = "";
SoftwareSerial zigbee(16,17);
char Insert_SQL[] = "INSERT INTO SensorData (Date, Time, Num, Sensor1, Sensor2, Sensor3) VALUES ('%s','%s','%s','%s','%s','%s')";
char Receive[] = "SELECT * FROM Final LIMIT 1";
char query2 [128];
//IPAddress server_addr(35,193,2,212);  // IP of the MySQL *server* here
String finalVal;
char hostname[] = "sql5.freemysqlhosting.net";
char user[] = "sql5486851";              // MySQL user login username
char password[] = "AV2VWZlUk5";        // MySQL user login password
char db[] = "sql5486851";
// WiFi card example
char query[] = "SELECT * FROM Final LIMIT 1";
//const char* ssid2 = "Arduinotest";
//const char* password2 =  "salamance";
const char* ssid2 = "The House Of Champions";
const char* password2 =  "i dont know";
IPAddress server_ip;
WiFiClient client;            // Use this for WiFi instead of EthernetClient
MySQL_Connection conn((Client *)&client);
char sensor2[] = "48";
char sensor3[] = "10";
void setup() {
  //Receive data from the three sensors here

  Serial.begin(115200);
  zigbee.begin(9600 );
  WiFi.begin(ssid2, password2);
 
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.println("Connecting to WiFi..");
  }
  Serial.println("Connected to the WiFi network");
  
}
void loop() {
 
  
  IPAddress ip = WiFi.localIP();
  //Serial.println(ip);
  IPAddress server_ip;
  WiFi.hostByName("sql5.freemysqlhosting.net",server_ip);
  //Serial.println(server_ip); // server_ip will contain the ip address of google.com
  //now figure out the current date/time
  DateTime.setServer("time.pool.aliyun.com");
  DateTime.setTimeZone("CST6CDT,M4.1.0,M10.5.0");
  DateTime.begin();
  if (!DateTime.isTimeValid()) {
    Serial.println("Failed to get time from server.");
  } else {
      //2022-04-04T02:43:55-0500
      String totalDate = DateTime.toISOString().c_str();
      //2022-04-04
      String currDate = totalDate.substring(0,10);
      char charDate[11];
      currDate.toCharArray(charDate, 11);
      //02:52:13 but will usually be only an hour
      String currTime = totalDate.substring(11,19);
      char charTime[9];
      currTime.toCharArray(charTime, 9);
      
    
    
      if (zigbee.available() > 0) {
        Serial.print("# bytes: ");
        Serial.println(zigbee.available());
        
        c = zigbee.readString();
        const char* readData = c.c_str();
        Serial.println(c);
        int myInts[3];
        int current = 0;
        char sensor[50];
        char data1[50];
        char data2[50];
        char data3[50];
        for (int i = 0; i < strlen(readData); i++){
          if (readData[i] == '-'){
            myInts[current] = i;
            current +=1;
            //Serial.println(i);
          }
        }
        current = 0;
        String convert1 = c.substring(0,myInts[0]);
        String convert2 = c.substring(myInts[0] + 1, myInts[1]);
        String convert3 = c.substring(myInts[1] + 1, myInts[2]);
        String convert4 = c.substring(myInts[2] + 1, strlen(readData));
        //Serial.println(c);
        Serial.println(convert1);
        convert1.toCharArray(sensor, 50);
        convert2.toCharArray(data1, 50);
        convert3.toCharArray(data2, 50);
        convert4.toCharArray(data3, 50);
        Serial.println(convert2);
        Serial.println(convert3);
        Serial.println(convert4);
        Serial.println(charDate);
        Serial.println(charTime);
        Serial.println("The message has been recieved");
        Serial.println("Connecting...");
          if (conn.connect(server_ip, 3306, user, password, db)) {
            delay(1000);
              // Initiate the query class instance
            MySQL_Cursor *cur_mem = new MySQL_Cursor(&conn);
            // Execute the query
            sprintf(query2, Insert_SQL, charDate, charTime, sensor,  data1, data2, data3);
            //Serial.println(query);
            cur_mem->execute(query2);
            delete cur_mem;
            Serial.println("Data recorded.");
            MySQL_Cursor *cur_mem2 = new MySQL_Cursor(&conn);
            cur_mem2->execute(Receive);
           // Fetch the columns and print them
            column_names *cols = cur_mem->get_columns();
            for (int f = 0; f < cols->num_fields; f++) {
              if (f < cols->num_fields-1) {
                Serial.print(", ");
              }
            }
            Serial.println();
            // Read the rows and print them
            row_values *row = NULL;
            do {
              row = cur_mem->get_next_row();
              if (row != NULL) {
                for (int f = 0; f < cols->num_fields; f++) {
                  Serial.print(row->values[f]);
                  finalVal = (row->values[f]);
                  if (f < cols->num_fields-1) {
                    Serial.print(", ");
                  }
                }
                Serial.println();
              }
            } while (row != NULL);
            // Deleting the cursor also frees up memory used
            delete cur_mem2;
            conn.close();
            Serial.print(finalVal);
          }
          else
            Serial.println("Connection failed.");
          delay(2000);
      }
  }
 
}
