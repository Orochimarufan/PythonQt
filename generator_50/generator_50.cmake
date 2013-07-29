
LIST(APPEND INCLUDEPATH ${GENERATORPATH})
LIST(APPEND INCLUDEPATH ${GENERATORPATH}/.)
LIST(APPEND INCLUDEPATH ${GENERATORPATH}/../common)

LIST(APPEND RESOURCES ${GENERATORPATH}/generator.qrc)

SET(RXXPATH ${GENERATORPATH}/parser)
include(${RXXPATH}/rxx.cmake)
include(${RXXPATH}/rpp/rpp.cmake)

LIST(APPEND HEADERS
	${GENERATORPATH}/generator.h
    ${GENERATORPATH}/main.h
    ${GENERATORPATH}/reporthandler.h
    ${GENERATORPATH}/typeparser.h
    ${GENERATORPATH}/typesystem.h
    ${GENERATORPATH}/asttoxml.h
    ${GENERATORPATH}/fileout.h
    ${GENERATORPATH}/generatorset.h
    ${GENERATORPATH}/metajava.h
    ${GENERATORPATH}/customtypes.h
    ${GENERATORPATH}/abstractmetabuilder.h
    ${GENERATORPATH}/abstractmetalang.h
    ${GENERATORPATH}/prigenerator.h
)

LIST(APPEND SOURCES
    ${GENERATORPATH}/generator.cpp
    ${GENERATORPATH}/main.cpp
    ${GENERATORPATH}/reporthandler.cpp
    ${GENERATORPATH}/typeparser.cpp
    ${GENERATORPATH}/typesystem.cpp
    ${GENERATORPATH}/asttoxml.cpp
    ${GENERATORPATH}/fileout.cpp
    ${GENERATORPATH}/generatorset.cpp
    ${GENERATORPATH}/metajava.cpp
    ${GENERATORPATH}/customtypes.cpp
    ${GENERATORPATH}/abstractmetabuilder.cpp
    ${GENERATORPATH}/abstractmetalang.cpp
    ${GENERATORPATH}/prigenerator.cpp
)

LIST(APPEND QT Core Xml)
