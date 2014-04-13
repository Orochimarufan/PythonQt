#!/bin/bash

#
#  file is included into the qmake systym in the common.prf file
#




#
#
#

main() {


 
  verbose=0   
  fix_release_lib=1 
  fix_debug_lib=0
     
  # parsing command line options
  while getopts ":vh?dra" opt; do
    case $opt in
      h)
        echo "Help for osx-file-dylib  -[vh]
                v : verbose output
                d : fix debug libs
                r : fix release libs (default)
                a : fix all libs
             " >&2
        exit
        ;;
      v)
        echo "-v was triggered!" >&2
        verbose=1 # means it is on
        ;;
      d)
        fix_debug_lib=1 # means it is on
        ;;
      r)
        fix_release_lib=1 # means it is on
        ;;
      a)
        fix_release_lib=1 
        fix_debug_lib=1
        ;;
      \?)
        echo "Invalid option: -$OPTARG" >&2
        ;;
    esac
  done



  BASEPATH=`pwd`

  if [ $verbose == 1 ] ; then
     echo "Basepath = " $BASEPATH
     ls -l *.dylib
  fi


  # first the release files
  if [ $fix_release_lib == 1 ] ; then 
    fixit libPythonQt.1.0.0.dylib libPythonQt_QtAll.1.0.0.dylib $verbose
  fi
  
  # then the debug libs
  if [ $fix_debug_lib == 1 ] ; then 
    fixit libPythonQt_d.1.0.0.dylib libPythonQt_QtAll_d.1.0.0.dylib $verbose
  fi

  if [ $verbose ] ; then
    #tput bold
    echo $LIBPYTHONQT
    #tput sgr0
    otool -L $LIBPYTHONQT
    #install_name_tool -id $FULLLIBPYTHONQT  $FULLLIBPYTHONQT 
    #otool -L $LIBPYTHONQT

    #tput bold
    echo $LIBPYTHONQTALL
    #tput sgr0
    otool -L $LIBPYTHONQTALL
    #install_name_tool -id $FULLLIBPYTHONQTALL  $FULLLIBPYTHONQTALL 

    #install_name_tool -change  libPythonQt.1.dylib $FULLLIBPYTHONQT $LIBPYTHONQTALL

    #otool -L $LIBPYTHONQTALL
  fi  
}







function fixit {
  #
  #  fixit(LIBPYTHONQT, LIBPYTHONQTALL, VERBOSE)
  #  
    
 
  LIBPYTHONQT=$1
  LIBPYTHONQTALL=$2
  VERBOSE=$3
   
  BASEPATH=`pwd`
  FULLLIBPYTHONQT=$BASEPATH"/"$LIBPYTHONQT
  FULLLIBPYTHONQTALL=$BASEPATH"/"$LIBPYTHONQTALL


  if [ -e $LIBPYTHONQT ]
  then
    #tput bold
    echo "fixing " $LIBPYTHONQT
    #tput sgr0
    #otool -L $LIBPYTHONQT
    install_name_tool -id $FULLLIBPYTHONQT  $FULLLIBPYTHONQT
    #otool -L $LIBPYTHONQT
  else
    #tput bold
    echo "[Warning] " $LIBPYTHONQT " is missing here:" `pwd`
    #tput sgr0
  fi


  if [ -e $LIBPYTHONQTALL ]
  then
    #tput bold
    echo "fixing " $LIBPYTHONQTALL
    #tput sgr0
    #otool -L $LIBPYTHONQTALL
    install_name_tool -id $FULLLIBPYTHONQTALL  $FULLLIBPYTHONQTALL

    echo "libPython:" $LIBPYTHONQT    
    # if debug then
    if [[ $LIBPYTHONQTALL == *_d.*dylib ]]
    then 
      LIBPYTHONQT1=libPythonQt_d.1.dylib
    else
      LIBPYTHONQT1=libPythonQt.1.dylib
    fi
    
    install_name_tool -change  $LIBPYTHONQT1 $FULLLIBPYTHONQT $LIBPYTHONQTALL


    #otool -L $LIBPYTHONQTALL
  else
    #tput bold
    echo "[Warning] " $LIBPYTHONQTALL " is missing here:" `pwd`
    #tput sgr0
  fi



}



# now we actually call main
main $@











