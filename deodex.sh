#!/bin/bash

ERROR=0
smalibaksmali_dir=/home/vlara/Android/tool
api=9

clear; for x in `find -iname "*.odex"|sort`; do
    odexFile=${x/\.\//}
    [ -e ${file1/odex/jar} ] && JarFile=${odexFile/odex/jar} || Jarfile=${odexFile/odex/apk}

    echo "Uncompiling $odexFile"
    java -Xmx512m -jar $smalibaksmali_dir/baksmali.jar -a $api -x $odexFile -o $odexFile.out

    if [ -e $odexFile.out ]; then
        java -Xmx512m -jar $smalibaksmali_dir/smali.jar $odexFile.out -o $odexFile-classes.dex
    else
       ERROR=1
    fi

    if [ -e $odexFile-classes.dex ]; then
        echo "Adding classes.dex to $JarFile"
        mv $odexFile-classes.dex classes.dex
        jar uf $JarFile classes.dex
        rm -rf $odexFile.out $odexFile-classes.dex classes.dex
        rm $odexFile
    else
        rm -rf $odexFile.out $odexFile-classes.dex classes.dex
        ERROR=1
    fi
    echo
done

if [ $ERROR -eq 1 ]; then
    echo "Error(s) detected. *.odex files not deleted."
else
    echo "No Error(s)"
fi