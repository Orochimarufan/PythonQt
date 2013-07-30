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

SET(DIRS
	pygments
)

qt_wrap_cpp(GEN_MOC ${HEADERS})

add_executable(NicePyConsole ${SOURCES} ${GEN_MOC})
if(PythonQt_Qt5)
	qt_use_modules(NicePyConsole Core Gui Widgets)
else()
	qt_use_modules(NicePyConsole Core Gui)
endif()

get_property(PythonQt_lib TARGET ${PythonQt} PROPERTY LOCATION)
get_property(PythonQt_QtAll_lib TARGET ${PythonQt_QtAll} PROPERTY LOCATION)
target_link_libraries(NicePyConsole ${PythonQt_lib} ${PythonQt_QtAll_lib} ${PYTHON_LIBRARIES})

foreach(FILE ${FILES})
	SET(OUT "${CMAKE_CURRENT_BINARY_DIR}/${FILE}")
	SET(IN "${CMAKE_CURRENT_SOURCE_DIR}/${FILE}")
	add_custom_command(OUTPUT "${OUT}"
		COMMAND "${CMAKE_COMMAND}" -E copy "${IN}" "${OUT}"
		MAIN_DEPENDENCY "${IN}"
	)
	add_dependencies(NicePyConsole "${OUT}")
endforeach()

foreach(DIR ${DIRS})
	SET(OUT "${CMAKE_CURRENT_BINARY_DIR}/${DIR}")
	SET(IN "${CMAKE_CURRENT_SOURCE_DIR}/${DIR}")
	add_custom_command(OUTPUT "${OUT}"
		COMMAND "${CMAKE_COMMAND}" -E copy_directory "${IN}" "${OUT}"
		MAIN_DEPENDENCY "${IN}"
	)
	add_dependencies(NicePyConsole "${OUT}")
endforeach()
