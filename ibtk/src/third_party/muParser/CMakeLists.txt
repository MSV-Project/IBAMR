set(KIT muparser)
set(UKIT MUPARSER)


set(kit_SRCS muParserError.cpp
  muParser.cpp
  muParserCallback.cpp
  muParserBytecode.cpp
  muParserTokenReader.cpp
  muParserBase.cpp
)

add_library(muParser ${kit_SRCS})



