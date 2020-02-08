#pragma once

#include "MimphoniumSong.h"
#include <string>

class MimphoniumRepertoire
{
public:
	MimphoniumRepertoire();
	void AddSong(const MimphoniumSong& song);
	void OutputToArduinoSourceFileSet(const std::string& baseFilename);
private:
	std::vector<MimphoniumSong> _songs;

	void OutputAllSongsToCSourceFile(std::ostream& oss, const std::string hFilename);
	void OutputAllSongsToCHeaderFile(std::ostream& oss);
};