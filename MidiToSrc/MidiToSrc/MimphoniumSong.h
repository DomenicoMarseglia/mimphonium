#pragma once

#include "MimphoniumEvent.h"
#include <vector>
#include <string>

class MimphoniumSong
{
public:
	MimphoniumSong(const std::string& filename);
	std::string SrcSongName() const { return _sourceCodeSongName; }
	std::string UserFreindlySongName() const { return _title; }


	void OutputAsCSourceCode(std::ostream& oss);
private:
	std::string _title;
	std::string _sourceCodeSongName;
	std::vector <MimphoniumEvent> _events;

	bool IsValidSourceNameCharacter(const char character);
	bool IsValidSourceNameFirstCharacter(const char character);
	std::string GetSourceNameFromFilename(const std::string& filename);
	std::string GetTitleFromFilename(const std::string& filename);
};