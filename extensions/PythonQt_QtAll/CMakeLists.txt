project(PythonQt_QtAll)

SET(GEN ../../generated_cpp${generated_cpp_suffix})

# Bindings
SET(HEADERS
	PythonQt_QtAll.h
)

SET(SOURCES
	PythonQt_QtAll.cpp
)

# Core
LIST(APPEND HEADERS
	${GEN}/com_trolltech_qt_core/com_trolltech_qt_core0.h
	${GEN}/com_trolltech_qt_core/com_trolltech_qt_core1.h
	${GEN}/com_trolltech_qt_core/com_trolltech_qt_core2.h
)

LIST(APPEND SOURCES
	${GEN}/com_trolltech_qt_core/com_trolltech_qt_core0.cpp
	${GEN}/com_trolltech_qt_core/com_trolltech_qt_core1.cpp
	${GEN}/com_trolltech_qt_core/com_trolltech_qt_core2.cpp
	${GEN}/com_trolltech_qt_core/com_trolltech_qt_core_init.cpp
)

# Gui
LIST(APPEND HEADERS
	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui0.h
	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui1.h
	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui2.h
	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui3.h
	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui4.h
	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui5.h
	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui6.h
	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui7.h
	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui8.h
	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui9.h
)

LIST(APPEND SOURCES
	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui0.cpp
	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui1.cpp
	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui2.cpp
	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui3.cpp
	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui4.cpp
	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui5.cpp
	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui6.cpp
	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui7.cpp
	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui8.cpp
	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui9.cpp
	${GEN}/com_trolltech_qt_gui/com_trolltech_qt_gui_init.cpp
)

# Network
LIST(APPEND HEADERS
	${GEN}/com_trolltech_qt_network/com_trolltech_qt_network0.h
)

LIST(APPEND SOURCES
	${GEN}/com_trolltech_qt_network/com_trolltech_qt_network0.cpp
	${GEN}/com_trolltech_qt_network/com_trolltech_qt_network_init.cpp
)

# OpenGL
LIST(APPEND HEADERS
	${GEN}/com_trolltech_qt_opengl/com_trolltech_qt_opengl0.h
)

LIST(APPEND SOURCES
	${GEN}/com_trolltech_qt_opengl/com_trolltech_qt_opengl0.cpp
	${GEN}/com_trolltech_qt_opengl/com_trolltech_qt_opengl_init.cpp
)

# Sql
LIST(APPEND HEADERS
	${GEN}/com_trolltech_qt_sql/com_trolltech_qt_sql0.h
)

LIST(APPEND SOURCES
	${GEN}/com_trolltech_qt_sql/com_trolltech_qt_sql0.cpp
	${GEN}/com_trolltech_qt_sql/com_trolltech_qt_sql_init.cpp
)

# Svg
LIST(APPEND HEADERS
	${GEN}/com_trolltech_qt_svg/com_trolltech_qt_svg0.h
)

LIST(APPEND SOURCES
	${GEN}/com_trolltech_qt_svg/com_trolltech_qt_svg0.cpp
	${GEN}/com_trolltech_qt_svg/com_trolltech_qt_svg_init.cpp
)

# uitools
LIST(APPEND HEADERS
	${GEN}/com_trolltech_qt_uitools/com_trolltech_qt_uitools0.h
)

LIST(APPEND SOURCES
	${GEN}/com_trolltech_qt_uitools/com_trolltech_qt_uitools0.cpp
	${GEN}/com_trolltech_qt_uitools/com_trolltech_qt_uitools_init.cpp
)

# WebKit
LIST(APPEND HEADERS
	${GEN}/com_trolltech_qt_webkit/com_trolltech_qt_webkit0.h
)

LIST(APPEND SOURCES
	${GEN}/com_trolltech_qt_webkit/com_trolltech_qt_webkit0.cpp
	${GEN}/com_trolltech_qt_webkit/com_trolltech_qt_webkit_init.cpp
)

# Xml
LIST(APPEND HEADERS
	${GEN}/com_trolltech_qt_xml/com_trolltech_qt_xml0.h
)

LIST(APPEND SOURCES
	${GEN}/com_trolltech_qt_xml/com_trolltech_qt_xml0.cpp
	${GEN}/com_trolltech_qt_xml/com_trolltech_qt_xml_init.cpp
)

#-------------------------------------------------------------------
# Build

include_directories(../../src)
add_definitions(-DPYTHONQT_QTALL_EXPORTS)
qt_wrap_cpp(GEN_MOC ${HEADERS})

SET(QT
	Core
	Gui
	Network
	OpenGL
	Sql
	Svg
	UiTools
	WebKit
	Xml
)

if(PythonQt_Qt5)
	LIST(APPEND QT
		Widgets
		WebKitWidgets
	)
endif()


add_library(PythonQt_QtAll SHARED ${SOURCES} ${GEN_MOC})
qt_use_modules(PythonQt_QtAll ${QT})

get_property(PythonQt_lib TARGET PythonQt PROPERTY LOCATION)
target_link_libraries(PythonQt_QtAll ${PythonQt_lib} ${PYTHON_LIBRARIES})
