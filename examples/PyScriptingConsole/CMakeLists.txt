project(PyScriptingConsole)

file(GLOB SOURCES *.cpp)
file(GLOB HEADERS *.h)

if(NOT TARGET ${PythonQt_QtAll})
	find_package(${PythonQt_QtAll} CONFIG REQUIRED)
endif()

qt_wrap_cpp(GEN_MOC ${HEADERS})#replacable by automoc

add_executable(${PROJECT_NAME} ${SOURCES} ${GEN_MOC})
target_link_libraries(${PROJECT_NAME} ${PythonQt_QtAll})
