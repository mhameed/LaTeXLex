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

arrayStart "\\begin"{lBrace}"array"{rBrace}
arrayEnd "\\end"{lBrace}"array"{rBrace}

verbatim ("verbatim"|"Verbatim")
verbatimStart "\\begin"{lBrace}{verbatim}{rBrace}
verbatimEnd "\\end"{lBrace}{verbatim}{rBrace}

%x DOLLAR_MODE VERBATIM ARRAY
%%

"\\$" ECHO; /*protect escaped $ */

{verbatimStart} ECHO; yy_push_state(VERBATIM);
<VERBATIM>{verbatimEnd} ECHO; yy_pop_state();


  /*These rules are order dependent.*/
"\$\$" ECHO; /*These rules are order dependent.*/
<DOLLAR_MODE>"\$" yy_pop_state(); /*These rules are order dependent.*/
<DOLLAR_MODE>{arrayStart} ECHO; yy_push_state(ARRAY);
<DOLLAR_MODE>(\r?\n) printf(" "); /*These rules are order dependent.*/
"\$" yy_push_state(DOLLAR_MODE); /*These rules are order dependent.*/

({arrayStart}) ECHO; yy_push_state(ARRAY);
<ARRAY>(("\\\\"([[:blank:]])*(\r?\n))|"\\\\"([[:blank:]])*) printf("\\\\\n");
<ARRAY>"&"([[:blank:]])*(\r?\n) printf("& ");
<ARRAY>(\r?\n) printf("\n"); 
<ARRAY>({arrayEnd}) printf("\n"); ECHO; yy_pop_state(); 

\r?\n printf("\n"); /*Just in case*/
<VERBATIM>(\r?\n) printf("\n"); /*Just in case*/

