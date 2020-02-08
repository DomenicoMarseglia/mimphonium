#include <arduino.h>
#include <Wire.h>
#include "Adafruit_MCP23017.h"
#include "Playback.h"
#include "Song.h"

#define NUM_OUTPUTS_PER_IO_EXPANDER 16
#define NUM_OUTPTUS (NUM_OUTPUTS_PER_IO_EXPANDER * NUM_IO_EXPANDERS)

const t_Song * m_song = NULL;
unsigned long m_songStartTime = 0;
unsigned int m_eventIndex = 0;
unsigned long _tempoMultiplier = 1;
unsigned long _tempoDivider = 1;
char _transpose = 0;
unsigned long _noteOnTime = NORMAL_NOTE_ON_TIME;
uint16_t m_expanderImages[NUM_IO_EXPANDERS];
Adafruit_MCP23017 mcp[NUM_IO_EXPANDERS];
unsigned long m_noteOffSongElapsedTimes[NUM_OUTPTUS];


void InitialisePlaybackSystem(void)
{
  for (unsigned int i=0;i<NUM_IO_EXPANDERS;++i)
  {
    mcp[i].begin(i);
    m_expanderImages[i]=0;    
  }

  for (unsigned int i=0;i<NUM_IO_EXPANDERS;++i)
  {
    for (unsigned int j=0;j<16;++j)
    {
      mcp[i].pinMode(j, OUTPUT);
    }
  }
  
  for (unsigned int i=0;i<NUM_OUTPTUS;++i)
  {
    m_noteOffSongElapsedTimes[i]=0;
  }
}

void InitiatePlayback(const t_Song * song, unsigned long tempoMultiplier, unsigned long tempoDivider, char transpose, unsigned long noteOnTime)
{
  m_eventIndex = 0;
  m_songStartTime = millis();
  m_song = song;

  _tempoMultiplier=tempoMultiplier;
  _tempoDivider=tempoDivider;
  _transpose=transpose;
  _noteOnTime = noteOnTime;
  
  Serial.print("Playback Initiated ");  
  Serial.print(song->pTitle);  
  Serial.print("\n");  

  Serial.print("tempoMultiplier=");  
  Serial.print(_tempoMultiplier);  
  Serial.print("\n");  

  Serial.print("tempoDivider=");  
  Serial.print(_tempoDivider);  
  Serial.print("\n"); 

  Serial.print("transpose=");  
  Serial.print((int)_transpose);  
  Serial.print("\n"); 

  Serial.print("noteOnTime=");  
  Serial.print(_noteOnTime);  
  Serial.print("\n"); 
}

#ifdef FULLSIZE_MIMPHONIUM
bool GetExpanderAndBitPosition(uint8_t note, uint16_t * p_expander, uint16_t * p_bitPosition)
{
  if ( (note >= FIRST_NOTE) && (note <= LAST_NOTE) )
  {
      *p_expander = (note - FIRST_NOTE) / 16;
      *p_bitPosition = (note - FIRST_NOTE) % 16;
      return true;
  }
  else
  {
      *p_expander = 0;
      *p_bitPosition = 0;
      return false;
  }
}
#endif

#ifdef MINI_MIMPHONIUM
bool GetExpanderAndBitPosition(uint8_t note, uint16_t * p_expander, uint16_t * p_bitPosition)
{
  switch(note)
  {
    default:
      *p_expander = 0;
      *p_bitPosition = 0;
      return false;
    case 83:
      *p_expander = 0;
      *p_bitPosition = 12;
      return true;
    case 88:
      *p_expander = 0;
      *p_bitPosition = 13;
      return true;
    case 90:
      *p_expander = 0;
      *p_bitPosition = 14;
      return true;
    case 92:
      *p_expander = 0;
      *p_bitPosition = 15;
      return true;
  }
}
#endif

void AddNoteToOutputImages(uint8_t note, unsigned long songElapsedTime)
{
//  Serial.print("Note "); 
//  Serial.print((unsigned int) note); 
//  Serial.print("added\n"); 
  unsigned long noteOffTime = songElapsedTime + _noteOnTime;

  if (note >= FIRST_NOTE && note <= LAST_NOTE)
  {
    m_noteOffSongElapsedTimes[note- FIRST_NOTE]= noteOffTime;   
    uint16_t expander;
    uint16_t bitPosition;
    if (GetExpanderAndBitPosition(note, &expander, &bitPosition))
    {
      m_expanderImages[expander] |= (1 << bitPosition);
      //Serial.print("Note "); 
      //Serial.print((unsigned int) note); 
      //Serial.print(" added. Expander "); 
      //Serial.print((unsigned int) expander); 
      //Serial.print(" bit "); 
      //Serial.print((unsigned int) bitPosition); 
      //Serial.print("\n"); 
    }
    else
    {
      Serial.print("Unhandled note "); 
      Serial.print((unsigned int) note); 
      Serial.print("\n"); 
    }
  }
  else
  {
    Serial.print("Note out of range "); 
    Serial.print((unsigned int) note); 
    Serial.print("\n"); 
  }
}

void RemoveExpiredNotesFromOutputImages(unsigned long songElapsedTime)
{
  for (unsigned int i=0;i<NUM_OUTPTUS;++i)
  {
    if (songElapsedTime > m_noteOffSongElapsedTimes[i])
    {
      uint8_t note = i + FIRST_NOTE;
      uint16_t expander;
      uint16_t bitPosition;      
      if (GetExpanderAndBitPosition(note , &expander,&bitPosition))
      {
        m_expanderImages[expander] &= ~(1 << bitPosition);  
      }
    }
  }
}

void SetOutputsFromImages()
{
  for (unsigned int i=0;i<NUM_IO_EXPANDERS;++i)
  {
//    Serial.print("Output "); 
//    Serial.print((unsigned int) i); 
//    Serial.print(" = "); 
//    Serial.print((unsigned int) m_expanderImages[i]); 
    mcp[i].writeGPIOAB(m_expanderImages[i]);
  }  
//    Serial.print("\n");     
}

bool IsRemainingUnexpiredNotes()
{
  for (unsigned int i=0;i<NUM_IO_EXPANDERS;++i)
  {
    if (m_expanderImages[i] != 0)
    {
      return true;
    }
  }  
  return false; 
}  

t_MidiEvent GetEventFromSong(const t_Song * pSong, uint16_t noteIndex)
{
  t_MidiEvent  returnValue;
  returnValue.timeStamp = pgm_read_word(&(pSong->pEvents[noteIndex].timeStamp));
  returnValue.note = pgm_read_byte(&(pSong->pEvents[noteIndex].note));
  return returnValue;
}

bool IsPlaying(void)
{
  return m_song != NULL;
}

void ProcessPlaybackLoop(void)
{
    if (m_song != NULL)
    {
      unsigned long songElapsedTime = millis()-m_songStartTime;
      bool noMoreNotesFound = true;
      do
      {
        t_MidiEvent event = GetEventFromSong(m_song, m_eventIndex);
        unsigned long noteOnTime =  (unsigned long)event.timeStamp * _tempoMultiplier / _tempoDivider;        

        //Serial.print("event.timeStamp=");
        //Serial.print(event.timeStamp);
        //Serial.print(" songElapsedTime=");
        //Serial.print(songElapsedTime);
        //Serial.print(" noteOnTime=");
        //Serial.print(noteOnTime);
        //Serial.print(" m_eventIndex=");
        //Serial.print(m_eventIndex);
        //Serial.print(" m_song->numEvents=");
        //Serial.print(m_song->numEvents);
        //Serial.print("\n");

        if ( (songElapsedTime > noteOnTime) && (m_eventIndex < m_song->numEvents))
        {
          uint8_t note = (event.note + _transpose);
          AddNoteToOutputImages(note,songElapsedTime);
          ++m_eventIndex;
          //Serial.print("Next index\n");
        }
        else
        {
          noMoreNotesFound = true; 
          //Serial.print("No more events\n");
        }
      } while (!noMoreNotesFound);
      
      RemoveExpiredNotesFromOutputImages(songElapsedTime);
      SetOutputsFromImages();
      
      if (m_eventIndex >= m_song->numEvents && !IsRemainingUnexpiredNotes())
      {
        Serial.print("Finished\n");  
        m_song = NULL;
      }
    }
    else
    {
      //Serial.print("m_song NULL\n");  
    }  
}
