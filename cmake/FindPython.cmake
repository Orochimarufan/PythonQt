# - Find python
# This module searches for both the python interpreter and the python libraries
# and determines where they are located
#
#
#  PYTHON_FOUND - The requested Python components were found
#  PYTHON_EXECUTABLE  - path to the Python interpreter
#  PYTHON_INCLUDE_DIRS - path to the Python header files
#  PYTHON_LIBRARIES - the libraries to link against for python
#  PYTHON_VERSION - the python version
#

#=============================================================================
# Copyright 2010 Branan Purvine-Riley
#           2013 Orochimarufan
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# * Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
# 
# * Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the distribution.
#
# * Neither the names of Kitware, Inc., the Insight Software Consortium,
#   nor the names of their contributors may be used to endorse or promote
#   products derived from this software without specific prior written
#   permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#=============================================================================

IF("3" STREQUAL "${Python_FIND_VERSION_MAJOR}")
  SET(PYTHON_3_OK "TRUE")
  SET(PYTHON_2_OK "FALSE") # redundant in version selection code, but skips a FOREACH
ELSE("3" STREQUAL "${Python_FIND_VERSION_MAJOR}")
  SET(PYTHON_2_OK "TRUE")
  # don't set PYTHON_3_OK to false here - if the user specified it we want to search for Python 2 & 3
ENDIF("3" STREQUAL "${Python_FIND_VERSION_MAJOR}")

# This is  heavily inspired by FindBoost.cmake, with the addition of a second version list to keep
# python 2 and python 3 separate
IF(Python_FIND_VERSION_EXACT)
  SET(_PYTHON_TEST_VERSIONS "${Python_FIND_VERSION_MAJOR}.${Python_FIND_VERSION_MINOR}")
ELSE(Python_FIND_VERSION_EXACT)
  # Version lists
  SET(_PYTHON_3_KNOWN_VERSIONS ${PYTHON_3_ADDITIONAL_VERSIONS}
    "3.3" "3.2" "3.1" "3.0")
  SET(_PYTHON_2_KNOWN_VERSIONS ${PYTHON_2_ADDITIONAL_VERSIONS}
    "2.7" "2.6" "2.5" "2.4" "2.3" "2.2" "2.1" "2.0" "1.6" "1.5")
  SET(_PYTHON_2_TEST_VERSIONS)
  SET(_PYTHON_3_TEST_VERSIONS)
  SET(_PYTHON_TEST_VERSIONS)
  IF(Python_FIND_VERSION)
    # python 3 versions
    IF(PYTHON_3_OK)
      FOREACH(version ${_PYTHON_3_KNOWN_VERSIONS})
        IF(NOT ${version} VERSION_LESS ${Python_FIND_VERSION})
        LIST(APPEND _PYTHON_3_TEST_VERSIONS ${version})
        ENDIF(NOT ${version} VERSION_LESS ${Python_FIND_VERSION})
      ENDFOREACH(version)
    ENDIF(PYTHON_3_OK)
    # python 2 versions
    IF(PYTHON_2_OK)
      FOREACH(version ${_PYTHON_2_KNOWN_VERSIONS})
        IF(NOT ${version} VERSION_LESS ${Python_FIND_VERSION})
          LIST(APPEND _PYTHON_2_TEST_VERSIONS ${version})
        ENDIF(NOT ${version} VERSION_LESS ${Python_FIND_VERSION})
      ENDFOREACH(version)
    ENDIF(PYTHON_2_OK)
  # all versions
  ELSE(Python_FIND_VERSION)
    IF(PYTHON_3_OK)
      LIST(APPEND _PYTHON_3_TEST_VERSIONS ${_PYTHON_3_KNOWN_VERSIONS})
    ENDIF(PYTHON_3_OK)
    IF(PYTHON_2_OK)
      LIST(APPEND _PYTHON_2_TEST_VERSIONS ${_PYTHON_2_KNOWN_VERSIONS})
    ENDIF(PYTHON_2_OK)
  ENDIF(Python_FIND_VERSION)
  # fix python3 version flags
  IF(PYTHON_3_OK)
    FOREACH(version ${_PYTHON_3_TEST_VERSIONS})
      IF(${version} VERSION_GREATER 3.1)
          LIST(APPEND _PYTHON_TEST_VERSIONS "${version}mu" "${version}m" "${version}u" "${version}")
      ELSE(${version} VERSION_GREATER 3.1)
        LIST(APPEND _PYTHON_TEST_VERSIONS ${version})
      ENDIF(${version} VERSION_GREATER 3.1)
    ENDFOREACH(version)
  ENDIF(PYTHON_3_OK)
  IF(PYTHON_2_OK)
    LIST(APPEND _PYTHON_TEST_VERSIONS ${_PYTHON_2_TEST_VERSIONS})
  ENDIF(PYTHON_2_OK)
ENDIF(Python_FIND_VERSION_EXACT)

SET(_PYTHON_EXE_VERSIONS)
FOREACH(version ${_PYTHON_TEST_VERSIONS})
  LIST(APPEND _PYTHON_EXE_VERSIONS python${version})
ENDFOREACH(version ${_PYTHON_TEST_VERSIONS})

IF(WIN32)
  SET(_PYTHON_REGISTRY_KEYS)
  FOREACH(version ${_PYTHON_TEST_VERSIONS})
    LIST(APPEND _PYTHON_REGISTRY_KEYS [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\${version}\\InstallPath])
  ENDFOREACH(version ${_PYTHON_TEST_VERSIONS})
  # this will find any standard windows Python install before it finds anything from Cygwin
  FIND_PROGRAM(PYTHON_EXECUTABLE NAMES python ${_PYTHON_EXE_VERSIONS} PATHS ${_PYTHON_REGISTRY_KEYS})
ELSE(WIN32)
  FIND_PROGRAM(PYTHON_EXECUTABLE NAMES ${_PYTHON_EXE_VERSIONS} PATHS)
ENDIF(WIN32)

EXECUTE_PROCESS(COMMAND "${PYTHON_EXECUTABLE}" "-c" "from sys import *; stdout.write('%i.%i.%i' % version_info[:3])" OUTPUT_VARIABLE PYTHON_VERSION)

# Get our library path and include directory from python
IF(${PYTHON_VERSION} VERSION_GREATER 3.1)
  SET(_PYTHON_SYSCONFIG "sysconfig")
  SET(_PYTHON_SC_INCLUDE "sysconfig.get_path('include')")
ELSE()
  SET(_PYTHON_SYSCONFIG "distutils.sysconfig")
  SET(_PYTHON_SC_INCLUDE "distutils.sysconfig.get_python_inc()")
ENDIF()

IF(WIN32)
  EXECUTE_PROCESS(
    COMMAND "${PYTHON_EXECUTABLE}" -c "import ${_PYTHON_SYSCONFIG}; import sys; sys.stdout.write(${_PYTHON_SYSCONFIG}.get_config_var('prefix'))"
    OUTPUT_VARIABLE _PYTHON_PREFIX
  )
  EXECUTE_PROCESS(
    COMMAND "${PYTHON_EXECUTABLE}" -c "import ${_PYTHON_SYSCONFIG}; import sys; sys.stdout.write(${_PYTHON_SYSCONFIG}.get_config_var('py_version_nodot'))"
    OUTPUT_VARIABLE _PYTHON_VERSION_MAJOR
  )
  SET(_PYTHON_LIBRARY_PATH ${_PYTHON_PREFIX}/libs)
  SET(_PYTHON_LIBRARY_NAME libpython${_PYTHON_VERSION_MAJOR}.a)
ELSE(WIN32)
  EXECUTE_PROCESS(
    COMMAND "${PYTHON_EXECUTABLE}" -c "import ${_PYTHON_SYSCONFIG}; import sys; sys.stdout.write(${_PYTHON_SYSCONFIG}.get_config_var('LIBDIR'))"
    OUTPUT_VARIABLE _PYTHON_LIBRARY_PATH
  )
  EXECUTE_PROCESS(
    COMMAND "${PYTHON_EXECUTABLE}" -c "import ${_PYTHON_SYSCONFIG}; import sys; sys.stdout.write(${_PYTHON_SYSCONFIG}.get_config_var('LDLIBRARY'))"
    OUTPUT_VARIABLE _PYTHON_LIBRARY_NAME
  )
  # Multiarch
  EXECUTE_PROCESS(
    COMMAND "${PYTHON_EXECUTABLE}" -c "import ${_PYTHON_SYSCONFIG}; import sys; sys.stdout.write(${_PYTHON_SYSCONFIG}.get_config_vars().get('MULTIARCH', 'PYTHON_LIBRARY_MULTIARCH-NOTFOUND'))"
    OUTPUT_VARIABLE _PYTHON_LIBRARY_MULTIARCH
  )
  IF(NOT "${_PYTHON_LIBRARY_MULTIARCH}" STREQUAL "PYTHON_LIBRARY_MULTIARCH-NOTFOUND")
    SET(_PYTHON_LIBRARY_PATH_X ${_PYTHON_LIBRARY_PATH})
    SET(_PYTHON_LIBRARY_PATH)
    FOREACH(path ${_PYTHON_LIBRARY_PATH_X})
      LIST(APPEND _PYTHON_LIBRARY_PATH "${path}/${_PYTHON_LIBRARY_MULTIARCH}" "${path}")
    ENDFOREACH(path)
  ENDIF(NOT "${_PYTHON_LIBRARY_MULTIARCH}" STREQUAL "PYTHON_LIBRARY_MULTIARCH-NOTFOUND")
ENDIF(WIN32)
EXECUTE_PROCESS(COMMAND "${PYTHON_EXECUTABLE}"
  "-c" "import ${_PYTHON_SYSCONFIG}; import sys; sys.stdout.write(${_PYTHON_SC_INCLUDE})"
  OUTPUT_VARIABLE PYTHON_INCLUDE_DIR
)

FIND_FILE(PYTHON_LIBRARY ${_PYTHON_LIBRARY_NAME} PATHS ${_PYTHON_LIBRARY_PATH} NO_DEFAULT_PATH)
FIND_FILE(PYTHON_HEADER "Python.h" PATHS ${PYTHON_INCLUDE_DIR} NO_DEFAULT_PATH)

set(PYTHON_INCLUDE_DIRS ${PYTHON_INCLUDE_DIR})
set(PYTHON_LIBRARIES ${PYTHON_LIBRARY})

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Python
  REQUIRED_VARS PYTHON_EXECUTABLE PYTHON_HEADER PYTHON_LIBRARY
  VERSION_VAR PYTHON_VERSION
)

MARK_AS_ADVANCED(PYTHON_EXECUTABLE)
MARK_AS_ADVANCED(PYTHON_INCLUDE_DIRS)
MARK_AS_ADVANCED(PYTHON_LIBRARIES)
MARK_AS_ADVANCED(PYTHON_VERSION)

