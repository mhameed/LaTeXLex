/* 
 * Copyright 2006-2010 Mesar Hameed, Emma Cliffe 
 * 
 * This file is part of LaTeXLex.
 *
 * LaTeXLex is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * LaTeXLex is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with LaTeXLex.  If not, see <http://www.gnu.org/licenses/>.
 */

%option stack
nan ([^A-Za-z])
newline (" "|\t|(\r?\n))
lBrace ([[:blank:]])*"{"([[:blank:]])*
rBrace ([[:blank:]])*"}"

verbatim ("verbatim"|"Verbatim")
verbatimStart "\\begin"{lBrace}{verbatim}{rBrace}
verbatimEnd "\\end"{lBrace}{verbatim}{rBrace}

%x COMMENT VERBATIM
%%

"%" yy_push_state(COMMENT);
"\\vskip" yy_push_state(COMMENT);
<COMMENT>(.*)/(\r?\n) yy_pop_state(); /*eat up comments*/

{verbatimStart} ECHO; yy_push_state(VERBATIM);
<VERBATIM>{verbatimEnd} ECHO; yy_pop_state();

\r?\n printf("\n"); /*Just in case*/
<VERBATIM>(\r?\n) printf("\n"); /*Just in case*/

