TEMPLATE = subdirs

CONFIG += ordered
SUBDIRS = src extensions  # tests examples

QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.9
#contains(QT_MAJOR_VERSION, 5) {
#SUBDIRS += generator_50
#} else {
#SUBDIRS += generator
#}
