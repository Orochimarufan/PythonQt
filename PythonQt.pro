TEMPLATE = subdirs

CONFIG += ordered
SUBDIRS = src extensions tests examples

#contains(QT_MAJOR_VERSION, 5) {
#SUBDIRS += generator_50
#} else {
#SUBDIRS += generator
#}
