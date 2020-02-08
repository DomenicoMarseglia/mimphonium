#include "MimphoniumSong.h"
#include "MidiFile.h"

#include <stdlib.h>
#include <string.h>
#include <algorithm>

bool operator < (const MimphoniumEvent& lhs, const MimphoniumEvent& rhs) { return lhs.GetTimestamp() < rhs.GetTimestamp(); }

MimphoniumSong::MimphoniumSong(const std::string & filename)
{
	smf::MidiFile inputfile(filename);

	_title = GetTitleFromFilename(filename);
	_sourceCodeSongName = GetSourceNameFromFilename(filename);

	for (int trackNumber = 0; trackNumber < inputfile.getNumTracks(); ++trackNumber)
	{
		printf("NumEvents in track %d=%d\n", trackNumber, inputfile.getEventCount(trackNumber));

		int highestNoteFound = 0;
		int lowestNoteFound = 127;

		smf::MidiEventList& eventList = inputfile[trackNumber];
		for (int eventNumber = 0; eventNumber < inputfile.getEventCount(trackNumber); ++eventNumber)
		{
			smf::MidiEvent event = eventList.getEvent(eventNumber);
			int command = event.getCommandByte();
			int velocity = event.getP2();

			if ((((command & 0xF0) == 0x90)) && (velocity != 0))
			{
				int note = event.getP1();

				_events.push_back(MimphoniumEvent(event.tick, note));

				if (note > highestNoteFound)
				{
					highestNoteFound = note;
				}
				if (note < lowestNoteFound)
				{
					lowestNoteFound = note;
				}
				///				printf("Note on Time=%d,note=%d,velocity=%d\n", event.tick, event.getP1(), event.getP2());
				printf("\t{%d,%d},\n", event.tick / 4, note);
			}
		}

		std::sort(_events.begin(), _events.end());

		printf("\\\\\tLowestNote = %d, highestNote = %d, range = %d\n", lowestNoteFound, highestNoteFound, highestNoteFound - lowestNoteFound);
	}
}

void MimphoniumSong::OutputAsCSourceCode(std::ostream& oss)
{
	std::string eventsArrayName = SrcSongName() + "Events";

	oss << "\n";
	oss << "const t_MidiEvent " << eventsArrayName << "[] PROGMEM =\n";
	oss << "{\n";

	size_t numEvents = _events.size();

	for (size_t i = 0; i < numEvents; ++i)
	{
		MimphoniumEvent event = _events[i];
		oss << "    {" << event.GetTimestamp() << "," << event.GetNote() << "}";
		if (i != numEvents - 1)
		{
			oss << ",";
		}
		oss << "\n";
	}
	oss << "};\n";
	oss << "\n";

	oss << "const t_Song " << SrcSongName() << " =\n";
	oss << "{\n";
	oss << "    \"" << UserFreindlySongName() << "\",\n";
	oss << "    &" << eventsArrayName << ",\n";
	oss << "    sizeof(" << eventsArrayName << ") / sizeof(" << eventsArrayName << "[0])\n";
	oss << "};\n";
	oss << "\n";
}

bool MimphoniumSong::IsValidSourceNameCharacter(const char character)
{
	if ((character >= 'A' && character <= 'Z') ||
		(character >= 'a' && character <= 'z') ||
		(character >= '0' && character <= '0') ||
		(character == '_'))
	{
		return true;
	}
	else
	{
		return false;
	}
}

bool MimphoniumSong::IsValidSourceNameFirstCharacter(const char character)
{
	if ((character >= 'A' && character <= 'Z') ||
		(character >= 'a' && character <= 'z') ||
		(character == '_'))
	{
		return true;
	}
	else
	{
		return false;
	}
}

std::string MimphoniumSong::GetSourceNameFromFilename(const std::string & filename)
{
	char baseFilename[_MAX_FNAME];

	baseFilename[0] = '\0';
	_splitpath_s(filename.c_str(), NULL, 0, NULL, 0, baseFilename, _MAX_FNAME, NULL, 0);
	
	size_t len = strnlen_s(baseFilename, _MAX_FNAME);
	if (len > 0)
	{
		if (!IsValidSourceNameFirstCharacter(baseFilename[0]))
		{
			baseFilename[0] = '_';
		}
		if (len > 1)
		{
			for (size_t i = 1; i < len; ++i)
			{
				if (!IsValidSourceNameCharacter(baseFilename[i]))
				{
					baseFilename[i] = '_';
				}
			}
		}
	}
	return std::string(baseFilename);
}

std::string MimphoniumSong::GetTitleFromFilename(const std::string& filename)
{
	char baseFilename[_MAX_FNAME];

	baseFilename[0] = '\0';
	_splitpath_s(filename.c_str(), NULL, 0, NULL, 0, baseFilename, _MAX_FNAME, NULL, 0);
	return std::string(baseFilename);
}