find_package(Qt5Core REQUIRED)

# aliases
macro(qt_use_modules)
  qt5_use_modules(${ARGN})
endmacro()

macro(qt_wrap_cpp)
  qt5_wrap_cpp(${ARGN})
endmacro()

macro(qt_add_resources)
  qt5_add_resources(${ARGN})
endmacro()
