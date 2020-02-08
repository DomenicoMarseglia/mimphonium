#include "ByronBy30.h"
#include <arduino.h>

#define BYRON_BY30_INPUT_PIN 2
#define BYRON_BY30_CODE_NUM_BYTES 5


int lastPinState = 0;
unsigned long lastPinTransitionTime = 0;
unsigned char bitCount = 0;
unsigned char byteCount = 0;
unsigned char receivedCodeScratchPad[BYRON_BY30_CODE_NUM_BYTES];
unsigned char lastReceivedCode[BYRON_BY30_CODE_NUM_BYTES];
bool newCodeReceived = false;

void  ByronBy30Setup(void)
{
  for (unsigned char i = 0;i < BYRON_BY30_CODE_NUM_BYTES;++i)
  {  
    lastReceivedCode[i] = 0;
    receivedCodeScratchPad[i] = 0;
  }

  pinMode(BYRON_BY30_INPUT_PIN, INPUT);
  lastPinState = digitalRead(BYRON_BY30_INPUT_PIN);
  lastPinTransitionTime = micros();
}

bool ByronBy30IsButtonPressDetected(void)
{
  bool returnValue = newCodeReceived;
  newCodeReceived = false;
  return returnValue;
}

bool ByronBy30IsCodeMatch(const unsigned char * code, unsigned char numBytesToMatch)
{
  for (unsigned char i = 0; i < numBytesToMatch; ++i)
  {
    if (code[i] != lastReceivedCode[i])
    {
       return false;
    } 
  }
  return true;
}


// This function must be called regularly from the Arduino loop.
// It relies on being called regularly to achieve the timing necessary to decode the
// radio signal transmitted by the transmitters.
// In a setup which is just spinning idly waiting for a button to be pressed, this 
// seems to work quite well. 
// If other tasks are added to the loop, then they must cooperate with this
// routine and always relinquish control in a short period of time.
void ByronBy30ProcessLoop(void)
{
  int newPinState = digitalRead(BYRON_BY30_INPUT_PIN);
  
  if (newPinState != lastPinState)
  {
    unsigned long time = micros();
    unsigned long elapsedTime = time-lastPinTransitionTime;
    lastPinTransitionTime = time;
    lastPinState = newPinState;
    if ( (elapsedTime > 1500) || (elapsedTime < 400) )
    {
      bitCount = 0;
      byteCount = 0;
      for (unsigned char i = 0;i < BYRON_BY30_CODE_NUM_BYTES;++i)
      {  
        receivedCodeScratchPad[i]=0;
      }
    }
    else
    {
      receivedCodeScratchPad[byteCount] <<= 1;
      if (elapsedTime < 750)
      {
        receivedCodeScratchPad[byteCount] |= 1;  
      }
      
      ++bitCount;
      if (bitCount >= 8)
      {
        bitCount=0;
        ++byteCount;
        if (byteCount >= BYRON_BY30_CODE_NUM_BYTES)
        {
          for (unsigned char i=0;i<BYRON_BY30_CODE_NUM_BYTES;++i)
          {  
            lastReceivedCode[i]=receivedCodeScratchPad[i];
          }
          newCodeReceived = true;
          Serial.print("Byron code received");

          for (unsigned char i=0;i<BYRON_BY30_CODE_NUM_BYTES;++i)
          {  
            Serial.print(" ");
            Serial.print(lastReceivedCode[i],HEX);
          }
          Serial.print("\r\n");
        }
      }
    }     
  }
}
