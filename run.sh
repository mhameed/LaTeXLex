#!/bin/bash

# Copyright 2006-2010 Mesar Hameed, Emma Cliffe 
# 
# This file is part of LaTeXLex.
#
# LaTeXLex is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# LaTeXLex is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with LaTeXLex.  If not, see <http://www.gnu.org/licenses/>.

###
# a script to run the LaTeXLex tool on the supplied textfiles.
###

binDir="`pwd`/bin/"


STAGE1dot0="${binDir}stage1.0"
STAGE1dot1="${binDir}stage1.1"
STAGE1dot2="${binDir}stage1.2"
STAGE1dot3="${binDir}stage1.3"
STAGE2dot0="${binDir}stage2.0"
STAGE2dot1="${binDir}stage2.1"
STAGE2dot2="${binDir}stage2.2"
STAGE3dot0="${binDir}stage3.0"


usage() {
echo "Usage: $0 [options] <filename>, produces filename.out"
echo "$0 <filename>, standard reprocessing of file, produces filename.out"
echo -e "\t--no-utf8-greek, skips substitution of tex greek by utf-8 greek"
echo -e "\t--no-utf8-symb, skips substitution of maths tex alternative alphabet symbols by utf-8 maths alternative alphabet symbols"

# should be deleted? #echo -e "\t-w[rap], additional reformatting of lines"
# should be deleted? #echo -e "\t-p[reprocess] <arg> [-notex/-n], preprocesses the file with the specified preprocessing filter <arg>, useful to remove personal LaTeX oddities"
# should be deleted? #echo -e "\t-n[otex], skips LaTeX processing (stage2), useful for HTML/XML files, must be proceeded by -p."

exit
}

if [ -z $1 ] || [ $1 == "-help" ] || [ $1 == "--help" ] || [ $1 == "-h" ]; then
usage
fi

nogreek=0
nosymb=0
if [ "$1" == "--no-utf8-greek" ]; then
nogreek=1; shift
fi
if [ "$1" == "--no-utf8-symb" ]; then
nosymb=1; shift
fi
if [ "$1" == "--no-utf8-greek" ]; then
nogreek=1; shift
fi

fname="/tmp/`date +%y%m%d-%H%M`-$1"

$STAGE1dot0 <"$1" > ${fname}.1.0
$STAGE1dot1 < ${fname}.1.0 > ${fname}.1.1
$STAGE1dot2 < ${fname}.1.1 > ${fname}.1.2
$STAGE1dot3 < ${fname}.1.2 > ${fname}.1.3
$STAGE2dot0 < ${fname}.1.3 > ${fname}.2.0
$STAGE2dot1 < ${fname}.2.0 > ${fname}.2.1
$STAGE2dot2 < ${fname}.2.1 > ${fname}.2.2
$STAGE3dot0 < ${fname}.2.2 > ${fname}.3.0
cp ${fname}.3.0 ${fname}.final


if [ "$nogreek" == "0" ]; then
echo "replacing greek tex"
`pwd`/checkVars.sh ${fname}.3.0
sed -f `pwd`/GreekReplacement.sed < ${fname}.3.0 > ${fname}.3.greek
cp ${fname}.3.greek ${fname}.final

else
cp ${fname}.final ${fname}.3.greek

fi

if [ "$nosymb" == "0" ]; then
echo "replacing alternative math alphabet tex"
`pwd`/checkAlph.sh ${fname}.3.greek
sed -f `pwd`/CalScrReplacement.sed < ${fname}.3.greek > ${fname}.3.cal
sed -f `pwd`/FrakReplacement.sed < ${fname}.3.cal > ${fname}.3.frak
sed -f `pwd`/DoubleStruckReplacement.sed < ${fname}.3.frak > ${fname}.3.dstruck
cp ${fname}.3.dstruck ${fname}.final

fi


cp ${fname}.final "$1.out"
