project(PythonQt_QtAll)

file(GLOB SOURCES *.cpp)
file(GLOB HEADERS *.h)

set(QT Core Gui Network OpenGL Sql Svg UiTools Xml CACHE INTERNAL "")#for find_package in root CMakeLists
if(NOT QT_STATIC)#WebKit is not available in static builds
	set(QT ${QT} WebKit)
	set(WebKitWidgets WebKitWidgets)
endif()
if(PythonQt_Qt5)
	set(QT ${QT} PrintSupport Widgets ${WebKitWidgets} Multimedia MultimediaWidgets XmlPatterns CACHE INTERNAL "")
endif()

string(TOLOWER "${QT}" modules)

#-------------------------------------------------------------------
# Generated stuff
SET(GEN ../../generated_cpp${generated_cpp_suffix})
SET(GEN_HEADERS)
SET(GEN_SOURCES)

foreach(MODULE ${modules})
	SET(MODULE_TROLL com_trolltech_qt_${MODULE})
	SET(MODULE_BASE ${GEN}/${MODULE_TROLL}/${MODULE_TROLL})
	FILE(GLOB HFILES ${MODULE_BASE}*.h)
	FILE(GLOB CFILES ${MODULE_BASE}*.cpp)
	LIST(APPEND GEN_HEADERS ${HFILES})
	LIST(APPEND GEN_SOURCES ${CFILES})
endforeach()

#-------------------------------------------------------------------
# Build
set(PythonQt_QtAll ${PythonQt}_QtAll CACHE INTERNAL "")

if(NOT TARGET ${PythonQt})
	find_package(${PythonQt} CONFIG REQUIRED)
endif()

qt_wrap_cpp(GEN_MOC ${GEN_HEADERS})

add_library(${PythonQt_QtAll} ${SOURCES} ${HEADERS} ${GEN_SOURCES} ${GEN_MOC})
target_link_libraries(${PythonQt_QtAll} ${PythonQt} ${PYTHON_LIBRARIES})
target_include_directories(${PythonQt_QtAll} PUBLIC
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
	$<INSTALL_INTERFACE:include>
)
qt_use_modules(${PythonQt_QtAll} ${QT})

if(BUILD_SHARED_LIBS)
	target_compile_definitions(${PythonQt_QtAll} PRIVATE PYTHONQT_QTALL_EXPORTS)
else(BUILD_SHARED_LIBS)
	target_compile_definitions(${PythonQt_QtAll} PUBLIC  PYTHONQT_QTALL_STATIC)
endif(BUILD_SHARED_LIBS)

set_target_properties(${PythonQt_QtAll} PROPERTIES PUBLIC_HEADER "${HEADERS}")

include(CMakePackageConfigHelpers)
write_basic_package_version_file(
	"${PROJECT_BINARY_DIR}/${PythonQt_QtAll}ConfigVersion.cmake"
	VERSION ${PythonQt_VERSION}
	COMPATIBILITY AnyNewerVersion
)
configure_file(PythonQt_QtAllConfig.cmake.in "${PROJECT_BINARY_DIR}/${PythonQt_QtAll}Config.cmake" @ONLY)

install(TARGETS ${PythonQt_QtAll} EXPORT ${PythonQt_QtAll}Targets COMPONENT QtAll
	RUNTIME DESTINATION bin
	LIBRARY DESTINATION lib
	ARCHIVE DESTINATION lib
	PUBLIC_HEADER DESTINATION include/PythonQt)
set(LIB_CMAKE_PATH "lib/cmake/${PythonQt_QtAll}")
install(EXPORT ${PythonQt_QtAll}Targets DESTINATION ${LIB_CMAKE_PATH} COMPONENT QtAll-dev)
install(FILES ${PROJECT_BINARY_DIR}/${PythonQt_QtAll}Config.cmake
			  ${PROJECT_BINARY_DIR}/${PythonQt_QtAll}ConfigVersion.cmake
	DESTINATION ${LIB_CMAKE_PATH} COMPONENT QtAll-dev)
