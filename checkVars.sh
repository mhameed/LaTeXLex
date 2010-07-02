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

file="$1"

function check() {
c1=`grep -c "$1" "$file"`
c2=`grep -c "$2" "$file"`
#echo "c1=$c1, c2=$c2"

if [[ "$c1" -gt 0 && "$c2" -gt 0 ]]; then
    echo "warning be aware of $1 and $2"
fi
}

check "\\\\varepsilon" "\\\\epsilon"
check "\\\\theta" "\\\\vartheta"
check "\\\\pi" "\\\\varpi"
check "\\\\rho" "\\\\varrho"
check "\\\\varsigma" "\\\\sigma"
check "\\\\varphi" "\\\\phi"


