project(PythonQt)
cmake_minimum_required(VERSION 2.8.10)

IF(POLICY CMP0020)
    cmake_policy(SET CMP0020 NEW)
ENDIF()

include(CTestUseLaunchers OPTIONAL)

set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake ${CMAKE_MODULE_PATH})

#-----------------------------------------------------------------------------
# Version
SET(PythonQt_VERSION 2.2.0)

#-----------------------------------------------------------------------------
# Debug
option(PythonQt_DEBUG "Enable/Disable PythonQt debug output" OFF)
if(PythonQt_DEBUG)
	add_definitions(-DPYTHONQT_DEBUG)
else()
	remove_definitions(-DPYTHONQT_DEBUG)
endif()

if(NOT CMAKE_BUILD_TYPE)
	set(CMAKE_BUILD_TYPE Release)
endif()

#-----------------------------------------------------------------------------
# Qt
option(PythonQt_Qt5 "Use Qt 5.x" OFF)
if(PythonQt_Qt5)
	include(PythonQt_Qt_5x)
else(PythonQt_Qt5)
	include(PythonQt_Qt_4x)
endif(PythonQt_Qt5)

#-----------------------------------------------------------------------------
# The variable "generated_cpp_suffix" allows to conditionnally compile the generated wrappers
# associated with the Qt version being used.
set(generated_cpp_suffix "_${QT_VERSION_MAJOR}${QT_VERSION_MINOR}")

if("${generated_cpp_suffix}" STREQUAL "_48")
	set(generated_cpp_suffix "")
endif()
if("${generated_cpp_suffix}" STREQUAL "_46")
	set(generated_cpp_suffix "_47") # Also use 4.7 wrappers for 4.6.x version
endif()

# All 5.x use the same for now
if("${QT_VERSION_MAJOR}" STREQUAL "5")
	set(generated_cpp_suffix "_50")
endif()

#-----------------------------------------------------------------------------
# Generator
if(PythonQt_Qt5)
	add_subdirectory(generator_50 EXCLUDE_FROM_ALL)
	add_custom_target(generator)
	add_dependencies(generator pythonqt_generator)
endif()

# TODO

#-----------------------------------------------------------------------------
# Build options

#option(PythonQt_Wrap_QtAll "Make all Qt components available in python" OFF)
#
#set(qtlibs core gui network opengl sql svg uitools webkit xml xmlpatterns)
#foreach(qtlib ${qtlibs})
#	OPTION(PythonQt_Wrap_Qt${qtlib} "Make all of Qt${qtlib} available in python" OFF)
#endforeach()

# Force option if it applies
#if(PythonQt_Wrap_QtAll)
#	list(REMOVE_ITEM qtlibs xmlpatterns) # xmlpatterns wrapper does *NOT* build at all :(
#	foreach(qtlib ${qtlibs})
#		if(NOT ${PythonQt_Wrap_Qt${qtlib}})
#			set(PythonQt_Wrap_Qt${qtlib} ON CACHE BOOL "Make all of Qt${qtlib} available in python" FORCE)
#			message(STATUS "Enabling [PythonQt_Wrap_Qt${qtlib}] because of [PythonQt_Wrap_QtAll] evaluates to True")
#		endif()
#	endforeach()
#endif()

#-----------------------------------------------------------------------------
# Add extra sources
#foreach(qtlib core gui network opengl sql svg uitools webkit xml xmlpatterns)
#
#	if (${PythonQt_Wrap_Qt${qtlib}})
#
#		ADD_DEFINITIONS(-DPYTHONQT_WRAP_Qt${qtlib})
#
#		set(file_prefix generated_cpp${generated_cpp_suffix}/com_trolltech_qt_${qtlib}/com_trolltech_qt_${qtlib})
#
#		foreach(index RANGE 0 11)
#
#			# Source files
#			if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${file_prefix}${index}.cpp)
#				list(APPEND sources ${file_prefix}${index}.cpp)
#			endif()
#
#			# Headers that should run through moc
#			if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${file_prefix}${index}.h)
#				list(APPEND moc_sources ${file_prefix}${index}.h)
#			endif()
#
#		endforeach()
#
#		list(APPEND sources ${file_prefix}_init.cpp)
#
#	endif()
#endforeach()

#-----------------------------------------------------------------------------
# Find Python
option(PythonQt_Python3 "Use Python 3.x (3.3+)" OFF)
option(PythonQt_Python "Use specific Python Version" OFF)
if(PythonQt_Python)
	find_package(PythonLibs ${PythonQt_Python} REQUIRED EXACT)
elseif(PythonQt_Python3)
	find_package(PythonLibs 3.3 REQUIRED)
else()
	find_package(PythonLibs 2.6 REQUIRED)
endif()

if(NOT ${PYTHONLIBS_VERSION_STRING} VERSION_LESS 3)
	set(PythonQt_Python3 ON)
else()
	set(PythonQt_Python3 OFF)
endif()

include_directories(${PYTHON_INCLUDE_DIRS})
add_definitions(-DPYTHONQT_USE_RELEASE_PYTHON_FALLBACK)

#-----------------------------------------------------------------------------
# Library Name
# The variable PythonQt contains the PythonQt core library name
#   It incorporates library mayor versions
set(PythonQt PythonQt)

if(PythonQt_Qt5)
	set(PythonQt ${PythonQt}5)
endif()

if(PythonQt_Python3)
	set(PythonQt ${PythonQt}_3)
endif()

set(CMAKE_DEBUG_POSTFIX "_d")

message(STATUS "Building ${PythonQt} (Qt ${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH} + Python ${PYTHON_VERSION} | ${CMAKE_BUILD_TYPE})")

#-----------------------------------------------------------------------------
# Core
add_subdirectory(src)

#-----------------------------------------------------------------------------
# Tests
add_subdirectory(tests EXCLUDE_FROM_ALL)
# test alias
add_custom_target(test COMMAND tests/PythonQtTest WORKING_DIRECTORY ${CURRENT_BINARY_DIR})
add_dependencies(test PythonQtTest)

#-----------------------------------------------------------------------------
# Extenseions (QtAll)
add_subdirectory(extensions)
# QtAll alias
add_custom_target(QtAll)
add_dependencies(QtAll ${PythonQt_QtAll})

#-----------------------------------------------------------------------------
# Examples
include_directories(src)
include_directories(extensions/PythonQt_QtAll)
add_subdirectory(examples EXCLUDE_FROM_ALL)

#-----------------------------------------------------------------------------
# uninstall target
configure_file(
	"${CMAKE_CURRENT_SOURCE_DIR}/cmake/cmake_uninstall.cmake.in"
	"${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
	IMMEDIATE @ONLY)

add_custom_target(uninstall
	COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake)
