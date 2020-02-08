#ifndef __SONG_H__
#define __SONG_H__

typedef struct
{
	unsigned int timeStamp;
	unsigned char note;
} t_MidiEvent;

typedef struct
{
    const char * pTitle;
    const t_MidiEvent * const pEvents;
    unsigned int numEvents;
} t_Song;

extern const t_Song scale;
extern const t_Song westminster;

#if 0
extern const t_Song mariaVenistiANoi;
extern const t_Song tuScendiDalleStelle;
extern const t_Song gaudeTe;
extern const t_Song vader;
extern const t_Song pleaseExcuse;
extern const t_Song sixDeadRabbits;
extern const t_Song carolOfTheBells;
extern const t_Song dingDong;
extern const t_Song tuScendi2;
extern const t_Song pleaseExcuse2;
extern const t_Song harkTheHeraldAngel;
extern const t_Song joyToTheWorld;
extern const t_Song adesteFideles;
extern const t_Song away;
extern const t_Song letEmIn;
extern const t_Song stairwayToHeaven;
extern const t_Song dontYouWantMe;
extern const t_Song brewer;
extern const t_Song leftBankTwo;
extern const t_Song italianNationalAnthem;
extern const t_Song bulgarianNationalAnthem;
extern const t_Song gnossienne1;
extern const t_Song teDeum;
extern const t_Song rondeau; 

extern const t_Song sugarPlum;
extern const t_Song raiders;
extern const t_Song toccata;
#endif


#endif // __SONG_H__
