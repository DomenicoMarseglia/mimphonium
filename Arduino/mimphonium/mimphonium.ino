
#include <Wire.h>
#include "Adafruit_MCP23017.h"
#include "Repertoire.h"
#include "Playback.h"
#include "ByronBy30.h"

#define DOORBELL_BUTTON 3

// These are the codes that the four Byron BY30 push buttons I bought transmit.
// If you buy one, it almost certainly wont match any of these codes.
// To find out what code you button is transmitting, press the button and look
// at the debug serial output in your Arduino IDE.
const unsigned char byCode1[] = {0xB2, 0xB4, 0xCD, 0x2B};
const unsigned char byCode2[] = {0xCD, 0x34, 0xB3, 0x4C}; 
const unsigned char byCode3[] = {0xB3, 0x54, 0xAD, 0x52};
const unsigned char byCode4[] = {0xAB, 0x53, 0x4B, 0x2A}; 
  
void setup() 
{  
  Serial.begin(115200);
  Serial.print("Mimphonium initialising ...\n");

  pinMode(DOORBELL_BUTTON, INPUT_PULLUP); 
  InitialisePlaybackSystem();

  ByronBy30Setup();
  Serial.print("Initialise Complete\n");  
}



void loop() 
{
  if (!IsPlaying())
  {
    ByronBy30ProcessLoop();
  
    if (ByronBy30IsButtonPressDetected())
    {
      if (ByronBy30IsCodeMatch(byCode1, sizeof(byCode1)/sizeof(byCode1[0])))
      {
        InitiatePlayback(&westminster,8,1,0,NORMAL_NOTE_ON_TIME);    
      }
      else if (ByronBy30IsCodeMatch(byCode2, sizeof(byCode2)/sizeof(byCode2[0])))
      {
        InitiatePlayback(&StairwayToHeaven,3,2,30,NORMAL_NOTE_ON_TIME);    
      }
      else if (ByronBy30IsCodeMatch(byCode3, sizeof(byCode3)/sizeof(byCode3[0])))
      {
        InitiatePlayback(&LeftBankTwo,1,1,12,NORMAL_NOTE_ON_TIME);    
      }
      else if (ByronBy30IsCodeMatch(byCode4, sizeof(byCode4)/sizeof(byCode4[0])))
      {
        InitiatePlayback(&PreludeTeDeum,1,1,12,NORMAL_NOTE_ON_TIME);    
      }     
    }
  }

  if (!IsPlaying())
  {
    if (digitalRead(DOORBELL_BUTTON)==LOW)
    {
      InitiatePlayback(&scale,10,1,0,TEST_NOTE_ON_TIME);    
    }
  }
  


  ProcessPlaybackLoop();  
}
