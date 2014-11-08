add_subdirectory(PythonQt_QtAll)

add_custom_target(QtAll)
add_dependencies(QtAll ${PythonQt_QtAll})
