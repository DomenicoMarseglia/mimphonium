#ifndef __CONFIG_H__
#define __CONFIG_H__

// There are two models of mimphonium that share the same Arduino source code
// The full sized version has 32 notes, and the mini has just the 4 notes needed
// to play the Westminster chimes (as played by the clock in the Elizabeth tower,
// better known as Big Ben).
// To cope with these two builds variants, one or the other of these manifest
// variables should be enabled.
#define FULLSIZE_MIMPHONIUM
//#define MINI_MIMPHONIUM


#ifdef FULLSIZE_MIMPHONIUM
#define NUM_IO_EXPANDERS 2
#define FIRST_NOTE 72
#define LAST_NOTE 103

// These two not one times are the times for which the actuators are powered to
// make the hammer swing to hit the chime.
// The 'normal' time is what is used for normal playing. Ideally the hammer is
// powered until just before it hits the chime.
// The 'test' time is deliberately far too long. It is useful when debugging
// a new build because it is clear which way the hammer swings when powered.
// If the wires to the actuators are back to front, the hammer tries to swing
// backwards. With the normal time, this is surprisingly difficult to see
// becuase the hammer has a tendancy to bounce off the rebound arrestors.
#define NORMAL_NOTE_ON_TIME 60
#define TEST_NOTE_ON_TIME 200
#endif

#ifdef MINI_MIMPHONIUM
#define NUM_IO_EXPANDERS 1
#define FIRST_NOTE 83
#define LAST_NOTE 92

// On the face of it, these times should not be dependent on the number of notes.
// However, my two mimphonia also have different power supplies to power the coils.
#define NORMAL_NOTE_ON_TIME 100
#define TEST_NOTE_ON_TIME 300
#endif

#endif // __CONFIG_H__
