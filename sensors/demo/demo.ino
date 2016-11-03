#include <CapacitiveSensor.h>

/*
 * CapitiveSense Library Demo Sketch
 * Paul Badger 2008
 * Uses a high value resistor e.g. 10M between send pin and receive pin
 * Resistor effects sensitivity, experiment with values, 50K - 50M. Larger resistor values yield larger sensor values.
 * Receive pin is the sensor pin - try different amounts of foil/metal on this pin
 */

CapacitiveSensor   cs_2_4 = CapacitiveSensor(2,4);
// 10M resistor between pins 4 & 2, pin 2 is sensor pin, add a wire and or foil if desired

void setup()                    
{
  Serial.begin(9600);
}

void loop()                    
{
  int total1 = cs_2_4.capacitiveSensor(30);
  Serial.println(total1);    // print sensor output 1 
  delay(100);                // arbitrary delay to limit data to serial port 
}
