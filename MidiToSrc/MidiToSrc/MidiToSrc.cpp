
#include <iostream>
#include "MidiFile.h"

#include "MimphoniumRepertoire.h"



int main(int argc,
	char* argv[],
	char** envp)
{
    std::cout << "Hello World!\n"; 

	MimphoniumRepertoire repertoire;

	if (argc > 1)
	{
		for (int i = 1; i < argc; ++i)
		{
			MimphoniumSong song = MimphoniumSong(argv[i]);
			repertoire.AddSong(song);
		}

	}

	repertoire.OutputToArduinoSourceFileSet("Repertoire");
}
