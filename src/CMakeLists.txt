project(PythonQt_Core)

#-----------------------------------------------------------------------------
# Sources

file(GLOB_RECURSE SOURCES#compile gui subfolder
	./*.cpp

    ../generated_cpp${generated_cpp_suffix}/com_trolltech_qt_core_builtin/*.cpp
    ../generated_cpp${generated_cpp_suffix}/com_trolltech_qt_gui_builtin/*.cpp
)

#-----------------------------------------------------------------------------
# List headers.
# This is list is used for the install command.

file(GLOB HEADERS ./*.h)#exlude gui subfolder here, as it’s installed explicitly

#-----------------------------------------------------------------------------
# Headers that should run through moc

file(GLOB SOURCES_MOC
    PythonQt.h
    PythonQtSignalReceiver.h
    PythonQtStdDecorators.h
    gui/PythonQtScriptingConsole.h

    ../generated_cpp${generated_cpp_suffix}/com_trolltech_qt_core_builtin/*.h
    ../generated_cpp${generated_cpp_suffix}/com_trolltech_qt_gui_builtin/*.h
)

#-----------------------------------------------------------------------------
# Resources
set(SOURCES_QRC)

#-----------------------------------------------------------------------------
# Build the library
include_directories(${CMAKE_CURRENT_SOURCE_DIR})

qt_wrap_cpp(GEN_MOC ${SOURCES_MOC})
qt_add_resources(GEN_QRC ${SOURCES_QRC})

add_library(${PythonQt} ${SOURCES} ${GEN_MOC} ${GEN_QRC} ${HEADERS})

if(BUILD_SHARED_LIBS)
	target_compile_definitions(${PythonQt} PRIVATE PYTHONQT_EXPORTS)
else(BUILD_SHARED_LIBS)
	target_compile_definitions(${PythonQt} PUBLIC  PYTHONQT_STATIC)
endif(BUILD_SHARED_LIBS)

if(PythonQt_Qt5)
    qt_use_modules(${PythonQt} Core Gui Widgets)
else()
    qt_use_modules(${PythonQt} Core Gui)
endif()

target_link_libraries(${PythonQt} ${PYTHON_LIBRARIES})

#
# That should solve linkage error on Mac when the project is used in a superbuild setup
# See http://blog.onesadcookie.com/2008/01/installname-magic.html
#
set_target_properties(${PythonQt} PROPERTIES INSTALL_NAME_DIR "${CMAKE_INSTALL_PREFIX}/lib")

#-----------------------------------------------------------------------------
# Install library (on windows, put the dll in 'bin' and the archive in 'lib')

set_target_properties(${PythonQt} PROPERTIES PUBLIC_HEADER "${HEADERS}")

install(TARGETS ${PythonQt} EXPORT ${PythonQt}Targets COMPONENT core-dev
                RUNTIME DESTINATION bin COMPONENT core
                LIBRARY DESTINATION lib COMPONENT core
                ARCHIVE DESTINATION lib COMPONENT core
                PUBLIC_HEADER DESTINATION include/PythonQt)

#-----------------------------------------------------------------------------
# Export CMake Config

if(WIN32 AND NOT CYGWIN)
    set(LIB_CMAKE_PATH "cmake")
else()
    set(LIB_CMAKE_PATH "lib/cmake/${PythonQt}")
endif()

export(TARGETS ${PythonQt} FILE "${PROJECT_BINARY_DIR}/${PythonQt}Targets.cmake")
export(PACKAGE ${PythonQt})

# build tree
set(INCLUDE_DIRS "${PROJECT_SOURCE_DIR}" "${PROJECT_BINARY_DIR}")
configure_file(PythonQtConfig.cmake.in "${PROJECT_BINARY_DIR}/${PythonQt}Config.cmake" @ONLY)
# install tree
set(INCLUDE_DIRS "${CMAKE_INSTALL_PREFIX}/include")
configure_file(PythonQtConfig.cmake.in "${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/${PythonQt}Config.cmake" @ONLY)
# both
include(CMakePackageConfigHelpers)
write_basic_package_version_file(
	"${PROJECT_BINARY_DIR}/${PythonQt}ConfigVersion.cmake"
	VERSION ${PythonQt_VERSION}
	COMPATIBILITY AnyNewerVersion
)

install(DIRECTORY ./gui DESTINATION include/PythonQt FILES_MATCHING PATTERN "*.h")#install gui subfolder explicitly
install(EXPORT ${PythonQt}Targets DESTINATION "${LIB_CMAKE_PATH}" COMPONENT core-dev)
install(FILES ${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/${PythonQt}Config.cmake
              ${PROJECT_BINARY_DIR}/${PythonQt}ConfigVersion.cmake
        DESTINATION "${LIB_CMAKE_PATH}" COMPONENT core-dev)
