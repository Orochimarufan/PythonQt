project(PythonQt_Core)

file(GLOB_RECURSE SOURCES#compile gui subfolder
	./*.cpp

	../generated_cpp${generated_cpp_suffix}/com_trolltech_qt_core_builtin/*.cpp
	../generated_cpp${generated_cpp_suffix}/com_trolltech_qt_gui_builtin/*.cpp
)
file(GLOB HEADERS ./*.h)#exlude gui subfolder here, as it’s installed explicitly
file(GLOB SOURCES_MOC
	PythonQt.h
	PythonQtSignalReceiver.h
	PythonQtStdDecorators.h
	gui/PythonQtScriptingConsole.h

	../generated_cpp${generated_cpp_suffix}/com_trolltech_qt_core_builtin/*.h
	../generated_cpp${generated_cpp_suffix}/com_trolltech_qt_gui_builtin/*.h
)
set(SOURCES_QRC)

#-----------------------------------------------------------------------------
# Build the library
include_directories(${CMAKE_CURRENT_SOURCE_DIR})

qt_wrap_cpp(GEN_MOC ${SOURCES_MOC})
qt_add_resources(GEN_QRC ${SOURCES_QRC})

add_library(${PythonQt} ${SOURCES} ${GEN_MOC} ${GEN_QRC} ${HEADERS})
target_link_libraries(${PythonQt} ${PYTHON_LIBRARIES})
target_include_directories(${PythonQt} PUBLIC
	$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
	$<INSTALL_INTERFACE:include>
)
qt_use_modules(${PythonQt} Core Gui)
if(PythonQt_Qt5)
	qt_use_modules(${PythonQt} Widgets)
endif()

if(BUILD_SHARED_LIBS)
	target_compile_definitions(${PythonQt} PRIVATE PYTHONQT_EXPORTS)
else(BUILD_SHARED_LIBS)
	target_compile_definitions(${PythonQt} PUBLIC  PYTHONQT_STATIC)
endif(BUILD_SHARED_LIBS)

set_target_properties(${PythonQt} PROPERTIES PUBLIC_HEADER "${HEADERS}")
#
# That should solve linkage error on Mac when the project is used in a superbuild setup
# See http://blog.onesadcookie.com/2008/01/installname-magic.html
#
set_target_properties(${PythonQt} PROPERTIES INSTALL_NAME_DIR "${CMAKE_INSTALL_PREFIX}/lib")

include(CMakePackageConfigHelpers)
write_basic_package_version_file(
	"${PROJECT_BINARY_DIR}/${PythonQt}ConfigVersion.cmake"
	VERSION ${PythonQt_VERSION}
	COMPATIBILITY AnyNewerVersion
)
configure_file(PythonQtConfig.cmake.in "${PROJECT_BINARY_DIR}/${PythonQt}Config.cmake" @ONLY)

install(TARGETS ${PythonQt} EXPORT ${PythonQt}Targets COMPONENT core-dev
	RUNTIME DESTINATION bin COMPONENT core
	LIBRARY DESTINATION lib COMPONENT core
	ARCHIVE DESTINATION lib COMPONENT core
	PUBLIC_HEADER DESTINATION include/PythonQt)
install(DIRECTORY ./gui DESTINATION include/PythonQt FILES_MATCHING PATTERN "*.h")#install gui subfolder explicitly
set(LIB_CMAKE_PATH "lib/cmake/${PythonQt}")
install(EXPORT ${PythonQt}Targets DESTINATION ${LIB_CMAKE_PATH} COMPONENT core-dev)
install(FILES ${PROJECT_BINARY_DIR}/${PythonQt}Config.cmake
			  ${PROJECT_BINARY_DIR}/${PythonQt}ConfigVersion.cmake
	DESTINATION ${LIB_CMAKE_PATH} COMPONENT core-dev)
