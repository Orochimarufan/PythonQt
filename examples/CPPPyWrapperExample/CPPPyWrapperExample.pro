
TARGET   = CPPPyWrapperExample
TEMPLATE = app

mac:CONFIG -= app_bundle

DESTDIR           = ../../lib

contains(QT_MAJOR_VERSION, 5) {
  QT += widgets
}


include ( ../../build/common.prf )  
include ( ../../build/PythonQt.prf )  

SOURCES +=                    \
  CPPPyWrapperExample.cpp        

RESOURCES += CPPPyWrapperExample.qrc
