project(PythonQt_Tests)

file(GLOB SOURCES *.cpp)
file(GLOB HEADERS *.h)

if(NOT TARGET ${PythonQt})
	find_package(${PythonQt} CONFIG REQUIRED)
endif()

qt_wrap_cpp(GEN_HEADERS ${HEADERS})

add_executable(${PROJECT_NAME} ${SOURCES} ${GEN_HEADERS})
target_link_libraries(${PROJECT_NAME} ${PythonQt})
qt_use_modules(${PROJECT_NAME} Test Gui)
if(PythonQt_Qt5)
	qt_use_modules(${PROJECT_NAME} Widgets)
endif()
