project(PythonQtGenerator)

# straight qmake port
SET(HEADERS)
SET(SOURCES)
SET(QT)
SET(RESOURCES)
SET(INCLUDEPATH)
SET(DEFINES)

SET(GENERATORPATH ${CMAKE_CURRENT_SOURCE_DIR})
include(${GENERATORPATH}/generator_50.cmake)

LIST(APPEND HEADERS
	#generatorscript.h
	generatorsetqtscript.h
	metaqtscriptbuilder.h
	metaqtscript.h
	shellgenerator.h
	shellimplgenerator.h
	shellheadergenerator.h
	setupgenerator.h
)

LIST(APPEND SOURCES
	generatorsetqtscript.cpp
	metaqtscriptbuilder.cpp
	metaqtscript.cpp
	shellgenerator.cpp
	shellimplgenerator.cpp
	shellheadergenerator.cpp
	setupgenerator.cpp
)

include_directories(${INCLUDEPATH})
add_definitions(${DEFINITIONS})
qt_add_resources(GEN_QRC ${RESOURCES})
qt_wrap_cpp(GEN_MOC ${HEADERS})

add_executable(pythonqt_generator ${SOURCES} ${GEN_QRC} ${GEN_MOC})
qt_use_modules(pythonqt_generator ${QT})
