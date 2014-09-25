/*! \file examples/NicePyConsole/main.cpp
 * \brief shows how to create a small nice python console
 * \author "Melven Zoellner" <melven@topen.org>
 *
*/


// Qt-includes
#include <QApplication>

// PythonQt-includes
#include <PythonQt.h>
#include <PythonQt_QtAll.h>

// includes
#include "NicePyConsole.h"


// the main function
int main(int argc, char **argv)
{
    // create the Qt-application-object
    QApplication qapp(argc, argv);

    // initialize PythonQt
    PythonQt::init(PythonQt::IgnoreSiteModule | PythonQt::RedirectStdOut);
    PythonQt_QtAll::init();

    // Load pygments from resources
    PythonQt::self()->installDefaultImporter();
    PyObject *path = PySys_GetObject("path");
    PyList_Append(path, PyUnicode_FromString(":/lib"));

    // get the python-context and create the console widget
    PythonQtObjectPtr mainContext = PythonQt::self()->getMainModule();
    NicePyConsole console(NULL, mainContext);

    // just show the console...
    console.show();
    return qapp.exec();
}
