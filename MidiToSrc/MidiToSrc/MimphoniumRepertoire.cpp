#include "MimphoniumRepertoire.h"
#include <fstream>

MimphoniumRepertoire::MimphoniumRepertoire()
{

}

void MimphoniumRepertoire::AddSong(const MimphoniumSong& song)
{
	_songs.push_back(song);
}



void MimphoniumRepertoire::OutputAllSongsToCSourceFile(std::ostream& oss, const std::string hFilename)
{
	oss << "#include \"" << hFilename << "\"\n";
	oss << "#include <avr/pgmspace.h>\n";


	for (size_t i = 0; i < _songs.size(); ++i)
	{
		_songs[i].OutputAsCSourceCode(oss);
	}
}

void MimphoniumRepertoire::OutputAllSongsToCHeaderFile(std::ostream& oss)
{
	std::string includeGuard = "__REPERTOIRE_H__";

	oss << "#ifndef " << includeGuard << "\n";
	oss << "#define " << includeGuard << "\n";
	oss << "\n";
	oss << "#include \"Song.h\"\n";
	oss << "\n";
#if 0
	oss << "\n";
	oss << "typedef struct\n";
	oss << "{\n";
	oss << "    unsigned int timeStamp;\n";
	oss << "    unsigned char note;\n";
	oss << "} t_MidiEvent;\n";
	oss << "\n";
	oss << "typedef struct\n";
	oss << "{\n";
	oss << "    const char* pTitle;\n";
	oss << "    unsigned int tempoMultiplier;\n";
	oss << "    unsigned int tempoDivider;\n";
	oss << "    char transpose;\n";
	oss << "    const t_MidiEvent* const pEvents;\n";
	oss << "    unsigned int numEvents;\n";
	oss << "} t_Song;\n";
	oss << "\n";
#endif
	for (size_t i = 0; i < _songs.size(); ++i)
	{
		std::string songName = _songs[i].SrcSongName();
		oss << "extern const t_Song " << songName << "; \n";
	}

	oss << "\n";
	oss << "#endif // " << includeGuard << "\n";
}

void MimphoniumRepertoire::OutputToArduinoSourceFileSet(const std::string& baseFilename)
{
	std::string cFullFileName = baseFilename + ".c";
	std::string hFullFileName = baseFilename + ".h";

	std::ofstream cofs(cFullFileName, std::ofstream::out);
	std::ofstream hofs(hFullFileName, std::ofstream::out);

	OutputAllSongsToCHeaderFile(hofs);
	OutputAllSongsToCSourceFile(cofs, hFullFileName);

	cofs.close();
	hofs.close();
}