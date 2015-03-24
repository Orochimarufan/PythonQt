project(NicePyConsole)

file(GLOB SOURCES *.cpp)
file(GLOB HEADERS *.h)
file(GLOB RESOURCES *.qrc)

if(NOT TARGET ${PythonQt_QtAll})
	find_package(${PythonQt_QtAll} CONFIG REQUIRED)
endif()

if(NOT TARGET ${PythonQt})
	find_package(${PythonQt} CONFIG REQUIRED)
endif()


qt_wrap_cpp(GEN_MOC ${HEADERS})#replacable by automoc
qt_add_resources(GEN_RC ${RESOURCES})#replacable by autorcc

add_executable(${PROJECT_NAME} ${SOURCES} ${GEN_MOC} ${GEN_RC})
target_link_libraries(${PROJECT_NAME} ${PythonQt_QtAll} ${PythonQt})

qt_use_modules(${PROJECT_NAME} Core Gui)
if(PythonQt_Qt5)
    qt_use_modules(${PROJECT_NAME} Widgets)
endif()
