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

SET(FILES
	PygmentsHighlighter.py
	PythonCompleter.py
	module_completion.py
)

qt_wrap_cpp(GEN_MOC ${HEADERS})

add_executable(NicePyConsole ${SOURCES} ${GEN_MOC})
if(PythonQt_Qt5)
	qt_use_modules(NicePyConsole Core Gui Widgets)
else()
	qt_use_modules(NicePyConsole Core Gui)
endif()
get_property(PythonQt_lib TARGET PythonQt PROPERTY LOCATION)
get_property(PythonQt_QtAll_lib TARGET PythonQt_QtAll PROPERTY LOCATION)
target_link_libraries(NicePyConsole ${PythonQt_lib} ${PythonQt_QtAll_lib} ${PYTHON_LIBRARIES})

foreach(FILE ${FILES})
	add_custom_command(OUTPUT ${FILE}
		COMMAND cp "${CMAKE_CURRENT_SOURCE_DIR}/${FILE}" "${CMAKE_CURRENT_BINARY_DIR}/${FILE}"
	)
	add_dependencies(NicePyConsole ${FILE})
endforeach()
