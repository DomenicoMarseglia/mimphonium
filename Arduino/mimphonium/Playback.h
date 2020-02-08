#ifndef __PLAYBACK_H__
#define __PLAYBACK_H__

#include "Config.h"
#include "Song.h"


extern void InitialisePlaybackSystem(void);
extern void InitiatePlayback(const t_Song * song, unsigned long tempoMultiplier, unsigned long tempoDivider, char transpose, unsigned long noteOnTime);
extern void ProcessPlaybackLoop(void);
extern bool IsPlaying(void);

#endif // __PLAYBACK_H__
