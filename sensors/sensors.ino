#include <CapacitiveSensor.h>

CapacitiveSensor   cs_2_4 = CapacitiveSensor(2,4);        // 1M resistor between pins 2 & 4, pin 4 is sensor pin
CapacitiveSensor   cs_2_6 = CapacitiveSensor(2,6);        // 1M resistor between pins 2 & 6, pin 6 is sensor pin
CapacitiveSensor   cs_2_8 = CapacitiveSensor(2,8);        // 1M resistor between pins 2 & 8, pin 8 is sensor pin
CapacitiveSensor   cs_2_10 = CapacitiveSensor(2,10);        // 1M resistor between pins 2 & 10, pin 10 is sensor pin

 
void setup()                    
{
   cs_2_4.set_CS_AutocaL_Millis(0xFFFFFFFF);     // turn off autocalibrate on channel 1 - just as an example
   Serial.begin(9600);
}
 
void loop()                    
{
    long start = millis();
    long total1 =  cs_2_4.capacitiveSensor(30);
    long total2 =  cs_2_6.capacitiveSensor(30);
    long total3 =  cs_2_8.capacitiveSensor(30);
    long total4 =  cs_2_10.capacitiveSensor(30);
 
    Serial.print(total1);                  // print sensor output 1
    Serial.print(",");
    Serial.print(total2);                  // print sensor output 2
    Serial.print(",");
    Serial.print(total3);                  // print sensor output 3
    Serial.print(",");
    Serial.println(total4);                // print sensor output 4
 
    delay(10);                             // arbitrary delay to limit data to serial port 
}
