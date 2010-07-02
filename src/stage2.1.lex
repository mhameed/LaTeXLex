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
lbrace ([[:blank:]])*"{"([[:blank:]])*
rbrace ([[:blank:]])*"}"
/*first attempt to deal with tables sensibly */
tableenvs ("tabular""*"?) 
verbatim ("verbatim"|"Verbatim")
verbatimStart "\\begin"{lbrace}{verbatim}{rbrace}
verbatimEnd "\\end"{lbrace}{verbatim}{rbrace}

tableStart "\\begin"{lbrace}{tableenvs}{rbrace}
tableEnd "\\end"{lbrace}{tableenvs}{rbrace}

%x VERBATIM
%s TABLESTATE
%%

{verbatimStart} ECHO; yy_push_state(VERBATIM);
<VERBATIM>{verbatimEnd} ECHO; yy_pop_state();

{tableStart} ECHO; yy_push_state(TABLESTATE); /* Attempting tables */
<TABLESTATE>(("\\\\"([[:blank:]])*(\r?\n))|"\\\\"([[:blank:]])*) printf("\\\\\n"); /*Attempt to get each whole line of the table on one line  */
<TABLESTATE>"\\hline" printf("\\hline ---------"); /* highlight some of the table features */
<TABLESTATE>"&"([[:blank:]])*(\r?\n) printf("& "); /* attempt to get each whole line of the table on one line*/
<TABLESTATE>{tableEnd} ECHO; yy_pop_state();

\r?\n printf("\n"); /*Just in case*/
<VERBATIM>(\r?\n) printf("\n"); /*Just in case*/
