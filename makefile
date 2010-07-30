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

SDIR=./src/
BDIR=./bin/

SOURCES=$(wildcard $(SDIR)*.lex)
OBJECTS=$(patsubst $(SDIR)%,$(BDIR)%,$(patsubst %.lex,%,$(SOURCES)))

.PHONEY: all clean

all: $(BDIR) $(OBJECTS)

$(BDIR):
	mkdir $(BDIR)

$(BDIR)%: $(SDIR)%.lex
	flex $<
	gcc lex.yy.c -lfl -o $@
	@rm lex.yy.c

clean: 
	-rm $(OBJECTS) tests/*.out pipes/*.out
	-rmdir $(BDIR)

test: all
	./run_tests.sh
	./run_tests.sh pipe
