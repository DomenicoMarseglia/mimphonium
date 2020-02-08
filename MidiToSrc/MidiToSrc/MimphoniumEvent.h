#pragma once

class MimphoniumEvent
{
public:
	MimphoniumEvent(int timestamp, int note);
	int GetTimestamp() const { return _timeStamp; }
	int GetNote() const { return _note; }
private:
	int _timeStamp;
	int _note;
};