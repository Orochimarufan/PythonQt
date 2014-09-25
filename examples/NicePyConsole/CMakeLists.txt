project(NicePyConsole)

SET(HEADERS
	SimpleConsole.h
	NicePyConsole.h
	PygmentsHighlighter.h
	PythonCompleter.h
	PythonCompleterPopup.h
)

SET(SOURCES
	SimpleConsole.cpp
	NicePyConsole.cpp
	main.cpp
	PygmentsHighlighter.cpp
	PythonCompleter.cpp
	PythonCompleterPopup.cpp
)

SET(RESOURCES
    NPC.qrc
)

qt_wrap_cpp(GEN_MOC ${HEADERS})
qt_add_resources(GEN_RC ${RESOURCES})

add_executable(NicePyConsole ${SOURCES} ${GEN_MOC} ${GEN_RC})
if(PythonQt_Qt5)
        qt_use_modules(NicePyConsole Core Gui Widgets)
        # QtAll
        qt_use_modules(NicePyConsole Network OpenGL Sql Svg UiTools WebKit Xml WebKitWidgets Multimedia)
else()
	qt_use_modules(NicePyConsole Core Gui)
endif()

target_link_libraries(NicePyConsole ${PythonQt} ${PythonQt_QtAll} ${PYTHON_LIBRARIES})
