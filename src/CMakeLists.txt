project(PythonQt_Core)
cmake_minimum_required(VERSION 2.8.10)

#-----------------------------------------------------------------------------
# Sources

set(SOURCES
	PythonQtClassInfo.cpp
	PythonQtClassWrapper.cpp
	PythonQtConversion.cpp
	PythonQt.cpp
	PythonQtImporter.cpp
	PythonQtInstanceWrapper.cpp
	PythonQtMethodInfo.cpp
	PythonQtMisc.cpp
	PythonQtObjectPtr.cpp
	PythonQtQFileImporter.cpp
	PythonQtSignalReceiver.cpp
	PythonQtSlot.cpp
	PythonQtSignal.cpp
	PythonQtStdDecorators.cpp
	PythonQtStdIn.cpp
	PythonQtStdOut.cpp
	gui/PythonQtScriptingConsole.cpp

	../generated_cpp${generated_cpp_suffix}/PythonQt_QtBindings.cpp

	../generated_cpp${generated_cpp_suffix}/com_trolltech_qt_core_builtin/com_trolltech_qt_core_builtin0.cpp
	../generated_cpp${generated_cpp_suffix}/com_trolltech_qt_core_builtin/com_trolltech_qt_core_builtin_init.cpp
	../generated_cpp${generated_cpp_suffix}/com_trolltech_qt_gui_builtin/com_trolltech_qt_gui_builtin0.cpp
	../generated_cpp${generated_cpp_suffix}/com_trolltech_qt_gui_builtin/com_trolltech_qt_gui_builtin_init.cpp
)

#-----------------------------------------------------------------------------
# List headers.	This is list is used for the install command.

set(HEADERS
	PythonQtClassInfo.h
	PythonQtClassWrapper.h
	PythonQtConversion.h
	PythonQtCppWrapperFactory.h
	PythonQtDoc.h
	PythonQt.h
	PythonQtImporter.h
	PythonQtImportFileInterface.h
	PythonQtInstanceWrapper.h
	PythonQtMethodInfo.h
	PythonQtMisc.h
	PythonQtObjectPtr.h
	PythonQtQFileImporter.h
	PythonQtSignalReceiver.h
	PythonQtSlot.h
	PythonQtSignal.h
	PythonQtStdDecorators.h
	PythonQtStdIn.h
	PythonQtStdOut.h
	PythonQtSystem.h
	PythonQtVariants.h
	PythonQtPythonInclude.h
	../generated_cpp${generated_cpp_suffix}/PythonQt_QtBindings.h
)

#-----------------------------------------------------------------------------
# Headers that should run through moc

set(SOURCES_MOC
	PythonQt.h
	PythonQtSignalReceiver.h
	PythonQtStdDecorators.h
	gui/PythonQtScriptingConsole.h

	../generated_cpp${generated_cpp_suffix}/com_trolltech_qt_core_builtin/com_trolltech_qt_core_builtin0.h
	../generated_cpp${generated_cpp_suffix}/com_trolltech_qt_gui_builtin/com_trolltech_qt_gui_builtin0.h
)

#-----------------------------------------------------------------------------
# Resources
set(SOURCES_QRC )

#-----------------------------------------------------------------------------
# Build the library
include_directories(${CMAKE_CURRENT_SOURCE_DIR})

qt_wrap_cpp(GEN_MOC ${SOURCES_MOC})
qt_add_resources(GEN_QRC ${SOURCES_QRC})

add_library(${PythonQt} SHARED ${SOURCES} ${GEN_MOC} ${GEN_QRC} ${HEADERS})
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
configure_file(PythonQtConfigVersion.cmake.in "${PROJECT_BINARY_DIR}/${PythonQt}ConfigVersion.cmake" @ONLY)

install(EXPORT ${PythonQt}Targets DESTINATION "${LIB_CMAKE_PATH}" COMPONENT core-dev)
install(FILES ${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/${PythonQt}Config.cmake
			  ${PROJECT_BINARY_DIR}/${PythonQt}ConfigVersion.cmake
		DESTINATION "${LIB_CMAKE_PATH}" COMPONENT core-dev)

