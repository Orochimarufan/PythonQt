project(PyScriptingConsole)

set(SOURCES
    main.cpp
    PyExampleObject.cpp
)

set(HEADERS
    PyExampleObject.h
)

qt_wrap_cpp(MOC ${HEADERS})

add_executable(PyScriptingConsole ${MOC} ${SOURCES})
target_link_libraries(PyScriptingConsole ${PythonQt} ${PythonQt_QtAll})

qt_use_modules(PyScriptingConsole Core Gui Network OpenGL Svg UiTools WebKit Xml Multimedia Sql)
if(PythonQt_Qt5)
    qt_use_modules(PyScriptingConsole Widgets WebKitWidgets)
endif()

