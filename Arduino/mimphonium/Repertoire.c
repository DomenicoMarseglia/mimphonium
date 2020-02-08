#include "Repertoire.h"
#include <avr/pgmspace.h>

const t_MidiEvent AwayInAMangerEvents[] PROGMEM =
{
    {1920,77},
    {2880,82},
    {2880,70},
    {2880,74},
    {3840,82},
    {4800,84},
    {4800,75},
    {5280,86},
    {5760,82},
    {5760,74},
    {6720,82},
    {7680,86},
    {7680,72},
    {8160,87},
    {8640,89},
    {8640,70},
    {9600,89},
    {10560,91},
    {10560,71},
    {11520,87},
    {11520,72},
    {12480,75},
    {13440,84},
    {13440,72},
    {13920,86},
    {14400,87},
    {14400,69},
    {15360,87},
    {16320,89},
    {16320,65},
    {17280,86},
    {17280,70},
    {18240,86},
    {19200,82},
    {19200,65},
    {19680,86},
    {20160,84},
    {20160,64},
    {21120,79},
    {22080,82},
    {22080,60},
    {23040,81},
    {23040,65},
    {24000,67},
    {24960,77},
    {24960,69},
    {25920,82},
    {25920,70},
    {26880,82},
    {26880,74},
    {27840,84},
    {27840,75},
    {28320,86},
    {28800,82},
    {28800,74},
    {29760,82},
    {30720,86},
    {30720,72},
    {31200,87},
    {31680,89},
    {31680,70},
    {32640,89},
    {33600,91},
    {33600,71},
    {34560,87},
    {34560,72},
    {35520,60},
    {36480,84},
    {36480,63},
    {36960,86},
    {37440,87},
    {37440,65},
    {38400,87},
    {38400,67},
    {39360,89},
    {39360,69},
    {40320,86},
    {40320,70},
    {41280,86},
    {41280,66},
    {42240,82},
    {42240,67},
    {42720,86},
    {43200,84},
    {43200,63},
    {44160,79},
    {44160,60},
    {45120,81},
    {45120,65},
    {45120,75},
    {46080,82},
    {46080,70},
    {46080,74}
};

const t_Song AwayInAManger =
{
    "AwayInAManger",
    &AwayInAMangerEvents,
    sizeof(AwayInAMangerEvents) / sizeof(AwayInAMangerEvents[0])
};


const t_MidiEvent StairwayToHeavenEvents[] PROGMEM =
{
    {0,57},
    {240,60},
    {480,64},
    {720,69},
    {960,71},
    {960,56},
    {1200,64},
    {1440,60},
    {1680,71},
    {1920,72},
    {1920,55},
    {2160,64},
    {2400,60},
    {2640,72},
    {2880,66},
    {2880,54},
    {3120,62},
    {3360,57},
    {3600,66},
    {3840,64},
    {3840,53},
    {4080,60},
    {4320,57},
    {4560,60},
    {5040,64},
    {5280,60},
    {5520,57},
    {5760,47},
    {5760,55},
    {5760,59},
    {6000,45},
    {6000,57},
    {6000,60},
    {6240,57},
    {6240,60},
    {6240,45},
    {6960,45},
    {7200,53},
    {7440,52},
    {7680,45},
    {7920,57},
    {8160,60},
    {8400,64},
    {8640,56},
    {8640,71},
    {8880,64},
    {9120,60},
    {9360,71},
    {9600,72},
    {9600,55},
    {9840,64},
    {10080,60},
    {10320,72},
    {10560,66},
    {10560,54},
    {10800,62},
    {11040,57},
    {11280,66},
    {11520,64},
    {11520,53},
    {11760,60},
    {12000,57},
    {12240,60},
    {12720,64},
    {12960,60},
    {13200,57},
    {13440,47},
    {13440,55},
    {13440,59},
    {13680,45},
    {13680,57},
    {13680,60},
    {13920,45},
    {13920,57},
    {13920,60}
};

const t_Song StairwayToHeaven =
{
    "StairwayToHeaven",
    &StairwayToHeavenEvents,
    sizeof(StairwayToHeavenEvents) / sizeof(StairwayToHeavenEvents[0])
};


const t_MidiEvent LeftBankTwoEvents[] PROGMEM =
{
    {480,71},
    {768,67},
    {960,72},
    {1248,67},
    {1440,73},
    {1728,67},
    {1920,74},
    {3168,76},
    {3360,71},
    {3648,74},
    {5088,76},
    {5280,71},
    {5568,74},
    {6240,72},
    {6528,63},
    {8640,74},
    {8928,73},
    {9120,72},
    {9408,71},
    {9600,69},
    {10848,71},
    {11040,66},
    {11328,69},
    {12768,71},
    {12960,66},
    {13248,69},
    {13920,67},
    {14208,60},
    {16320,60},
    {16608,61},
    {16800,62},
    {17088,63},
    {17280,64},
    {18048,64},
    {18240,76},
    {18528,64},
    {18720,74},
    {19008,72},
    {20448,71},
    {20640,69},
    {20928,67},
    {21120,66},
    {21888,66},
    {22080,71},
    {22368,66},
    {22560,69},
    {22848,67},
    {24288,67},
    {24480,71},
    {24640,74},
    {24800,76},
    {24960,79},
    {26208,79},
    {26400,78},
    {26688,77},
    {26880,78},
    {27168,71},
    {27648,71},
    {28128,78},
    {28320,77},
    {28608,76},
    {28800,77},
    {29088,70},
    {29568,70},
    {30048,76},
    {30240,74},
    {30528,73},
    {30720,74}
};

const t_Song LeftBankTwo =
{
    "LeftBankTwo",
    &LeftBankTwoEvents,
    sizeof(LeftBankTwoEvents) / sizeof(LeftBankTwoEvents[0])
};


const t_MidiEvent PreludeTeDeumEvents[] PROGMEM =
{
    {0,69},
    {480,74},
    {960,74},
    {1200,76},
    {1440,78},
    {1920,74},
    {2400,81},
    {3120,79},
    {3360,78},
    {4080,78},
    {4320,79},
    {4800,81},
    {5040,79},
    {5280,78},
    {5520,79},
    {5760,81},
    {6240,76},
    {6480,74},
    {6720,76},
    {6960,78},
    {7200,76},
    {7680,69},
    {8160,74},
    {8640,74},
    {8880,76},
    {9120,78},
    {9600,74},
    {10080,81},
    {10800,79},
    {11040,78},
    {11760,78},
    {12000,79},
    {12240,81},
    {12480,78},
    {12720,79},
    {12960,76},
    {13680,74},
    {13920,74}
};

const t_Song PreludeTeDeum =
{
    "PreludeTeDeum",
    &PreludeTeDeumEvents,
    sizeof(PreludeTeDeumEvents) / sizeof(PreludeTeDeumEvents[0])
};
