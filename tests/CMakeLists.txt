# PythonQt Tests
# must be included from PythonQt main CMakeLists

project(PythonQt_Tests)

SET(HEADERS
	PythonQtTests.h
)

SET(SOURCES
	PythonQtTestMain.cpp
	PythonQtTests.cpp
)

qt_wrap_cpp(GEN_HEADERS ${HEADERS})

add_executable(PythonQtTest ${SOURCES} ${GEN_HEADERS})
if(PythonQt_Qt5)
	qt_use_modules(PythonQtTest Test Gui Widgets)
else()
	qt_use_modules(PythonQtTest Test Gui)
endif()

target_link_libraries(PythonQtTest ${PythonQt} ${PYTHON_LIBRARIES})
