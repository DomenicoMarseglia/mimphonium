#ifndef __BYRONBY30_H__
#define __BYRONBY30_H__

extern void ByronBy30ProcessLoop(void);
extern void ByronBy30Setup(void);
extern bool ByronBy30IsButtonPressDetected(void);
extern bool ByronBy30IsCodeMatch(const unsigned char * code, unsigned char numBytesToMatch);

#endif // __BYRONBY30_H__


