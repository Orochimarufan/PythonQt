project(PythonQt_QtAll)

# Bindings
SET(HEADERS
	PythonQt_QtAll.h
)

SET(SOURCES
	PythonQt_QtAll.cpp
)

#-------------------------------------------------------------------
# Generated stuff
SET(GEN ../../generated_cpp${generated_cpp_suffix})
SET(GEN_HEADERS)
SET(GEN_SOURCES)

foreach(MODULE core gui network opengl sql svg uitools webkit xml)
	SET(MODULE_TROLL com_trolltech_qt_${MODULE})
	SET(MODULE_BASE ${GEN}/${MODULE_TROLL}/${MODULE_TROLL})
	FILE(GLOB HFILES ${MODULE_BASE}*.h)
	FILE(GLOB CFILES ${MODULE_BASE}*.cpp)
	LIST(APPEND GEN_HEADERS ${HFILES})
	LIST(APPEND GEN_SOURCES ${CFILES})
endforeach()

## Core
#LIST(APPEND HEADERS
#	${GEN}/com_trolltech_qt_core/com_trolltech_qt_core0.h
#	${GEN}/com_trolltech_qt_core/com_trolltech_qt_core1.h
#	${GEN}/com_trolltech_qt_core/com_trolltech_qt_core2.h
#)

#LIST(APPEND SOURCES
#	${GEN}/com_trolltech_qt_core/com_trolltech_qt_core0.cpp
#	${GEN}/com_trolltech_qt_core/com_trolltech_qt_core1.cpp
#	${GEN}/com_trolltech_qt_core/com_trolltech_qt_core2.cpp
#	${GEN}/com_trolltech_qt_core/com_trolltech_qt_core_init.cpp
#)

## Gui
#LIST(APPEND HEADERS
#	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui0.h
#	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui1.h
#	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui2.h
#	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui3.h
#	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui4.h
#	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui5.h
#	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui6.h
#	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui7.h
#	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui8.h
#	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui9.h
#)

#LIST(APPEND SOURCES
#	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui0.cpp
#	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui1.cpp
#	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui2.cpp
#	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui3.cpp
#	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui4.cpp
#	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui5.cpp
#	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui6.cpp
#	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui7.cpp
#	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui8.cpp
#	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui9.cpp
#	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui_init.cpp
#)

## Network
#LIST(APPEND HEADERS
#	${GEN}/com_trolltech_qt_network/com_trolltech_qt_network0.h
#)

#LIST(APPEND SOURCES
#	${GEN}/com_trolltech_qt_network/com_trolltech_qt_network0.cpp
#	${GEN}/com_trolltech_qt_network/com_trolltech_qt_network_init.cpp
#)

## OpenGL
#LIST(APPEND HEADERS
#	${GEN}/com_trolltech_qt_opengl/com_trolltech_qt_opengl0.h
#)

#LIST(APPEND SOURCES
#	${GEN}/com_trolltech_qt_opengl/com_trolltech_qt_opengl0.cpp
#	${GEN}/com_trolltech_qt_opengl/com_trolltech_qt_opengl_init.cpp
#)

## Sql
#LIST(APPEND HEADERS
#	${GEN}/com_trolltech_qt_sql/com_trolltech_qt_sql0.h
#)

#LIST(APPEND SOURCES
#	${GEN}/com_trolltech_qt_sql/com_trolltech_qt_sql0.cpp
#	${GEN}/com_trolltech_qt_sql/com_trolltech_qt_sql_init.cpp
#)

## Svg
#LIST(APPEND HEADERS
#	${GEN}/com_trolltech_qt_svg/com_trolltech_qt_svg0.h
#)

#LIST(APPEND SOURCES
#	${GEN}/com_trolltech_qt_svg/com_trolltech_qt_svg0.cpp
#	${GEN}/com_trolltech_qt_svg/com_trolltech_qt_svg_init.cpp
#)

## uitools
#LIST(APPEND HEADERS
#	${GEN}/com_trolltech_qt_uitools/com_trolltech_qt_uitools0.h
#)

#LIST(APPEND SOURCES
#	${GEN}/com_trolltech_qt_uitools/com_trolltech_qt_uitools0.cpp
#	${GEN}/com_trolltech_qt_uitools/com_trolltech_qt_uitools_init.cpp
#)

## WebKit
#LIST(APPEND HEADERS
#	${GEN}/com_trolltech_qt_webkit/com_trolltech_qt_webkit0.h
#)

#LIST(APPEND SOURCES
#	${GEN}/com_trolltech_qt_webkit/com_trolltech_qt_webkit0.cpp
#	${GEN}/com_trolltech_qt_webkit/com_trolltech_qt_webkit_init.cpp
#)

## Xml
#LIST(APPEND HEADERS
#	${GEN}/com_trolltech_qt_xml/com_trolltech_qt_xml0.h
#)

#LIST(APPEND SOURCES
#	${GEN}/com_trolltech_qt_xml/com_trolltech_qt_xml0.cpp
#	${GEN}/com_trolltech_qt_xml/com_trolltech_qt_xml_init.cpp
#)

#-------------------------------------------------------------------
# Build
set(PythonQt_QtAll ${PythonQt}_QtAll CACHE INTERNAL "")

include_directories(../../src)
add_definitions(-DPYTHONQT_QTALL_EXPORTS)
qt_wrap_cpp(GEN_MOC ${GEN_HEADERS})

SET(QT Core Gui Network OpenGL Sql Svg UiTools WebKit Xml)
if(PythonQt_Qt5)
        LIST(APPEND QT Widgets WebKitWidgets Multimedia)
endif()


add_library(${PythonQt_QtAll} SHARED ${SOURCES} ${HEADERS} ${GEN_SOURCES} ${GEN_MOC})
qt_use_modules(${PythonQt_QtAll} ${QT})

target_link_libraries(${PythonQt_QtAll} ${PythonQt} ${PYTHON_LIBRARIES})

set_target_properties(${PythonQt_QtAll} PROPERTIES PUBLIC_HEADER "${HEADERS}")

install(TARGETS ${PythonQt_QtAll} EXPORT ${PythonQt_QtAll}Targets COMPONENT QtAll
				RUNTIME DESTINATION bin
				LIBRARY DESTINATION lib
				ARCHIVE DESTINATION lib
				PUBLIC_HEADER DESTINATION include/PythonQt)

#-----------------------------------------------------------------------------
# Export CMake Config

if(WIN32 AND NOT CYGWIN)
	set(LIB_CMAKE_PATH "cmake")
else()
	set(LIB_CMAKE_PATH "lib/cmake/${PythonQt_QtAll}")
endif()

export(TARGETS ${PythonQt_QtAll} ${PythonQt} FILE "${PROJECT_BINARY_DIR}/${PythonQt_QtAll}Targets.cmake")
export(PACKAGE ${PythonQt_QtAll})

# build tree
set(PythonQt_EXPORT_LOCAL ON)
set(INCLUDE_DIRS "${PROJECT_SOURCE_DIR}" "${PROJECT_BINARY_DIR}")
configure_file(PythonQt_QtAllConfig.cmake.in "${PROJECT_BINARY_DIR}/${PythonQt_QtAll}Config.cmake" @ONLY)
# install tree
set(PythonQt_EXPORT_LOCAL OFF)
set(INCLUDE_DIRS "${CMAKE_INSTALL_PREFIX}/include/PythonQt")
configure_file(PythonQt_QtAllConfig.cmake.in "${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/${PythonQt_QtAll}Config.cmake" @ONLY)
# both
configure_file(PythonQt_QtAllConfigVersion.cmake.in "${PROJECT_BINARY_DIR}/${PythonQt_QtAll}ConfigVersion.cmake" @ONLY)

install(EXPORT ${PythonQt_QtAll}Targets DESTINATION "${LIB_CMAKE_PATH}" COMPONENT QtAll-dev)
install(FILES ${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/${PythonQt_QtAll}Config.cmake
			  ${PROJECT_BINARY_DIR}/${PythonQt_QtAll}ConfigVersion.cmake
		DESTINATION "${LIB_CMAKE_PATH}" COMPONENT QtAll-dev)

