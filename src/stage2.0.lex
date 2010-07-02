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
/* first attempt to deal with itemize-like environments more sensibly */
listing ("itemize"|"enumerate"|"description"|"exitems") 
verbatim ("verbatim"|"Verbatim")
word ([[:blank:]]*[[:alnum:]]+[[:blank:]]*[,"."]*[" "]*)+
mathStart ("\$\$"|"\\["|"\\begin"{lbrace}("equation*"|"eqnarray"|"eqnarray*"){rbrace})
mathEnd ("\$\$"|"\\]"|"\\end"{lbrace}("equation*"|"eqnarray"|"eqnarray*"){rbrace})
verbatimStart "\\begin"{lbrace}{verbatim}{rbrace}
verbatimEnd "\\end"{lbrace}{verbatim}{rbrace}
listingStart "\\begin"{lbrace}{listing}{rbrace}
listingEnd "\\end"{lbrace}{listing}{rbrace}

%x VERBATIM BRACEMATH
%s LISTINGSTATE FORMAT  
%%

({mathStart}) ECHO; yy_push_state(BRACEMATH);
{verbatimStart} ECHO; yy_push_state(VERBATIM);
<VERBATIM>{verbatimEnd} ECHO; yy_pop_state();
<BRACEMATH>({mathEnd}) ECHO; yy_pop_state();

{listingStart} ECHO;  yy_push_state(LISTINGSTATE); /* Itemise-like environments */
<LISTINGSTATE>((\r?\n){0,2}([[:blank:]])*"\\item"(\r?\n){1,}) printf("\n\\item "); /* item is special inside this environment only */
<LISTINGSTATE>((\r?\n){0,2}([[:blank:]])*"\\item") printf("\n\\item"); /* item is special inside this environment only */
<LISTINGSTATE>(\r?\n)/({listingStart}) printf("\n"); 
<LISTINGSTATE>(\r?\n){0,2}{listingEnd} ECHO; yy_pop_state();
<LISTINGSTATE>(\r?\n)* printf("\n");
<LISTINGSTATE>{word}/(\r?\n) ECHO;  yy_push_state(FORMAT);
<FORMAT>(\r?\n)/({mathStart}|{verbatimStart}) printf("\n"); yy_pop_state();
<FORMAT>([[:blank:]])*(\r?\n)([[:blank:]])* printf(" "); yy_pop_state(); 
<FORMAT>(\r?\n)/([[:blank:]])*"\\item" yy_pop_state(); 
<FORMAT>(\r?\n)/({listingStart}|{listingEnd}) printf("\n"); yy_pop_state();
  /*<LISTINGSTATE>([[:blank:]])*(\r?\n)([[:blank:]])* printf(" ");*/

\r?\n printf("\n"); /*Just in case*/
<VERBATIM>(\r?\n) printf("\n"); /*Just in case*/


