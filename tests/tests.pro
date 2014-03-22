# --------- PythonQtTest profile -------------------
# Last changed by $Author: florian $
# $Id: PythonQt.pro 35381 2006-03-16 13:05:52Z florian $
# $Source$
# --------------------------------------------------
TARGET   = PythonQtTest
TEMPLATE = app
DESTDIR = ../lib

mac {
   CONFIG -= app_bundle
}

QT += testlib

include ( ../build/common.prf )
include ( ../build/PythonQt.prf )

contains(QT_MAJOR_VERSION, 5) {
  QT += widgets
}

HEADERS +=                    \
  PythonQtTests.h

SOURCES +=                    \
  PythonQtTestMain.cpp        \
  PythonQtTests.cpp

# run the tests after compiling
macx {
    QMAKE_POST_LINK = cd $${DESTDIR} && ./$${TARGET}
} else:win32 {
    QMAKE_POST_LINK = \"$${DESTDIR}/$${TARGET}.exe\"
} else:unix {
    # linux
    QMAKE_POST_LINK = cd $${DESTDIR} && LD_LIBRARY_PATH=$$(LD_LIBRARY_PATH):./ xvfb-run -a ./$${TARGET}
}
