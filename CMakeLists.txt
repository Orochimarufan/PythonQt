project(PythonQt)
cmake_minimum_required(VERSION 2.8.10)

set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake ${CMAKE_MODULE_PATH})

#-----------------------------------------------------------------------------
# Policy
IF(POLICY CMP0020)
    cmake_policy(SET CMP0020 NEW)
ENDIF()

IF(POLICY CMP0026) # Location property
    cmake_policy(SET CMP0026 NEW)
ENDIF()

IF(POLICY CMP0028) # ALIAS with ::
    cmake_policy(SET CMP0028 NEW)
ENDIF()

IF(POLICY CMP0037) # Reserved names
    cmake_policy(SET CMP0037 OLD) # we use "test"
ENDIF()

IF(POLICY CMP0046) # Missing Deps
    cmake_policy(SET CMP0046 NEW)
ENDIF()

IF(POLICY CMP0043) # Ignore COMPILE_DEFINITIONS_<Config>
    cmake_policy(SET CMP0043 NEW)
ENDIF()

include(CTestUseLaunchers OPTIONAL)

#-----------------------------------------------------------------------------
# Version
SET(PythonQt_VERSION 2.3.0)

#-----------------------------------------------------------------------------
# Debug
option(PythonQt_DEBUG "Enable/Disable PythonQt debug output" OFF)
if(PythonQt_DEBUG)
	add_definitions(-DPYTHONQT_DEBUG)
else()
	remove_definitions(-DPYTHONQT_DEBUG)
endif()

if(NOT CMAKE_BUILD_TYPE)
    if(PythonQt_DEBUG)
        set(CMAKE_BUILD_TYPE Debug)
    else()
	set(CMAKE_BUILD_TYPE Release)
    endif()
endif()

#-----------------------------------------------------------------------------
# Qt
option(PythonQt_Qt5 "Use Qt 5.x" ON)
if(PythonQt_Qt5)
	include(PythonQt_Qt_5x)
else(PythonQt_Qt5)
	include(PythonQt_Qt_4x)
endif(PythonQt_Qt5)

#-----------------------------------------------------------------------------
# The variable "generated_cpp_suffix" allows to conditionnally compile the generated wrappers
# associated with the Qt version being used.

if("${QT_VERSION_MAJOR}" STREQUAL "5")
    # NEW
    if(NOT ("${QT_VERSION_MINOR}" LESS "3"))
        set(generated_cpp_suffix "_53")
    else()
	set(generated_cpp_suffix "_50")
    endif()
else()
    # OLD
    set(generated_cpp_suffix "_${QT_VERSION_MAJOR}${QT_VERSION_MINOR}")
    if("${generated_cpp_suffix}" STREQUAL "_48")
            set(generated_cpp_suffix "")
    endif()
    if("${generated_cpp_suffix}" STREQUAL "_46")
            set(generated_cpp_suffix "_47") # Also use 4.7 wrappers for 4.6.x version
    endif()
endif()

#-----------------------------------------------------------------------------
# Generator
#add_subdirectory(generator EXCLUDE_FROM_ALL)
#add_custom_target(generator)
#add_dependencies(generator pythonqt_generator)

# TODO

#-----------------------------------------------------------------------------
# Find Python
option(PythonQt_Python3 "Use Python 3.x (3.3+)" ON)
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
if(PythonQt_Qt5)
    if(PythonQt_Python3)
        set(PythonQt Qt5Python3)
    else()
        set(PythonQt Qt5Python)
    endif()
elseif(PythonQt_Python3)
    set(PythonQt PythonQt_3)
else()
    set(PythonQt PythonQt)
endif()

set(CMAKE_DEBUG_POSTFIX "_d")

message(STATUS "Building ${PythonQt} (Qt ${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH} + Python ${PYTHONLIBS_VERSION_STRING} | ${CMAKE_BUILD_TYPE})")

#-----------------------------------------------------------------------------
# Core
add_subdirectory(src)
include_directories(src)

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
