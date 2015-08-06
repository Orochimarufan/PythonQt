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

set(generated_cpp_suffix "_${QT_VERSION_MAJOR}${QT_VERSION_MINOR}")
if("${generated_cpp_suffix}" STREQUAL "_55")
	set(generated_cpp_suffix "_54") # Also use 5.5 wrappers for 5.4
endif()
if("${generated_cpp_suffix}" STREQUAL "_51" OR "${generated_cpp_suffix}" STREQUAL "_52")
	set(generated_cpp_suffix "_50") # Also use 5.0 wrappers for 5.1.x and 5.2.x version
endif()
if("${generated_cpp_suffix}" STREQUAL "_46")
	set(generated_cpp_suffix "_47") # Also use 4.7 wrappers for 4.6.x version
endif()

#-----------------------------------------------------------------------------
# Generator
#add_subdirectory(generator EXCLUDE_FROM_ALL)
#add_custom_target(generator)
#add_dependencies(generator pythonqt_generator)

option(BUILD_SHARED_LIBS "build shared instead of static library")
#-----------------------------------------------------------------------------
# Find Python
option(PythonQtAll "Build complete Qt wrapper library" ON)
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
# To maintain ABI compatibility, the Qt major version as well as the Python major and minor version are needed
string(SUBSTRING ${PYTHONLIBS_VERSION_STRING} 0 1 python_major)
string(SUBSTRING ${PYTHONLIBS_VERSION_STRING} 2 1 python_minor)
set(PythonQt Qt${QT_VERSION_MAJOR}Python${python_major}${python_minor} CACHE INTERNAL "")

set(CMAKE_DEBUG_POSTFIX "_d")

#-----------------------------------------------------------------------------
# Core
add_subdirectory(src)
#-----------------------------------------------------------------------------
# Extenseions (QtAll)
if (${PythonQtAll})
	add_subdirectory(extensions)
	#find Qt imported targets for use in examples
	#the necessaty is a bug and will be probably be fixed in CMake 3.1 (http://public.kitware.com/Bug/view.php?id=15101)
	find_package(Qt5 CONFIG REQUIRED COMPONENTS ${QT})
	# Examples, depending on QtAll
	add_subdirectory(examples EXCLUDE_FROM_ALL)
endif()
#-----------------------------------------------------------------------------
# Tests
add_subdirectory(tests EXCLUDE_FROM_ALL)
add_custom_target(tests
	COMMAND PythonQt_Tests
	DEPENDS ${PythonQt}
	WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/src#preliminary hack to find the dll on windows
)
add_dependencies(tests PythonQt_Tests)

#-----------------------------------------------------------------------------
# uninstall target
configure_file(
	"${CMAKE_CURRENT_SOURCE_DIR}/cmake/cmake_uninstall.cmake.in"
	"${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
	IMMEDIATE @ONLY)
add_custom_target(uninstall COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake)

if(BUILD_SHARED_LIBS)
	set(LINK_TYPE "Shared")
else()
	set(LINK_TYPE "Static")
endif()
if(QT_STATIC)
	set(QT_LINK_TYPE "static")
else()
	set(QT_LINK_TYPE "shared")
endif()
if(${PythonQtAll})
	set(WrapAll " + ${PythonQt_QtAll}")
endif()
message(STATUS "Building ${PythonQt}${WrapAll} (${QT_LINK_TYPE} Qt ${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH} + Python ${PYTHONLIBS_VERSION_STRING} | ${CMAKE_BUILD_TYPE} | ${LINK_TYPE})")
