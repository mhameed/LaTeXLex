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

TDIR=./tests/
PDIR=./pipes/

# Run the specified stage, against all its input files.
# located in TDIR
#
function testStage() {
stage=$1
find ${TDIR}/ -iname "${stage}.*.input" | while read file; do
expected="${file%%input}expected"
out="${file%%input}out"
./bin/$stage <$file >$out
touch $expected
diff $expected $out
res=$?
if [ $res -ne 0 ]; then
echo "Failed: $file"
else
echo "Ok: $file"
fi
done
}

function simpletons() {
# actually running the tests.
testStage stage1.0
testStage stage1.1
testStage stage1.2
testStage stage1.3
testStage stage2.0
testStage stage2.1
testStage stage2.2
testStage stage3.0
}



function helper2() {
index="$1";
infile="$2";
outfile="$3";
expected="$4"; 
touch "$infile" "$outfile" "$expected"
./bin/stage${index} <$infile >$outfile
diff $expected $outfile
res=$?
if [ $res -ne 0 ]; then
echo "Failed: $outfile"
else
echo "Ok: $outfile"
fi
}

function helper1() {
file="$1";
index="1.0"
expected10="${file%%input}${index}.expected"
out10="${expected10%%expected}out"
helper2 $index $file $out10 $expected10

index="1.1"
expected11="${file%%input}${index}.expected"
out11="${expected11%%expected}out"
helper2 $index $expected10 $out11 $expected11

index="1.2"
expected12="${file%%input}${index}.expected"
out12="${expected12%%expected}out"
helper2 $index $expected11 $out12 $expected12

index="1.3"
expected13="${file%%input}${index}.expected"
out13="${expected13%%expected}out"
helper2 $index $expected12 $out13 $expected13

index="2.0"
expected20="${file%%input}${index}.expected"
out20="${expected20%%expected}out"
helper2 $index $expected13 $out20 $expected20

index="2.1"
expected21="${file%%input}${index}.expected"
out21="${expected21%%expected}out"
helper2 $index $expected20 $out21 $expected21

index="2.2"
expected22="${file%%input}${index}.expected"
out22="${expected22%%expected}out"
helper2 $index $expected21 $out22 $expected22

index="3.0"
expected30="${file%%input}${index}.expected"
out30="${expected30%%expected}out"
helper2 $index $expected22 $out30 $expected30

}

## run the whole pipe
function testAllStages() {
find ${PDIR}/ -iname "pipe.*.input" | while read file; do
helper1 "$file"
echo -e "\n\n----------------\n\n"
done
}

if [ "$1" == "pipe" ]; then
testAllStages
else
simpletons
fi
