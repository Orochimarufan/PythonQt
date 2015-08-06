project(PythonQt_Tests)

# automatically link plugins when linking to a static qt
# so far only of effect in msys2
if(NOT BUILD_SHARED_LIBS)
    set(CMAKE_AUTOSTATICPLUGINS ON)#https://github.com/Alexpux/MINGW-packages/issues/577
endif()

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
