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
%{
int curLines = 0;
int maxLines = 4;
%}
nan ([^A-Za-z])
whitespace (" "|\t|(\r?\n))
word ([[:blank:]]*[[:alnum:]]+[[:blank:]]*[,"."]*[" "]*)+
lbrace ([[:blank:]])*"{"([[:blank:]])*
rbrace ([[:blank:]])*"}"
/*Environments in which we preserve the layout */
preserve ("figure"|"disp"|"array"|("eqnarray""*"?)|"center"|"tt"|"em"|"quote"|"code"|"tightcode"|"equation"|"tabular""*"?|"itemize"|"enumerate"|"description"|"exitems"|"tabbing")
mathStart ("\$\$"|"\\["|"\\begin"{lbrace}"equation*"{rbrace})
mathEnd ("\$\$"|"\\]"|"\\end"{lbrace}"equation*"{rbrace})
verbatim ("verbatim"|"Verbatim")
verbatimStart "\\begin"{lbrace}{verbatim}{rbrace}
verbatimEnd "\\end"{lbrace}{verbatim}{rbrace}

preserveStart "\\begin"{lbrace}{preserve}{rbrace}
preserveEnd "\\end"{lbrace}{preserve}{rbrace}

%x BRACEMATH VERBATIM PRESERVESTATE 
%s FORMAT 
%%

(\r?\n){5,} printf("\n\n\n\n"); 

{verbatimStart} /*printf("VS");*/ ECHO; yy_push_state(VERBATIM);
<VERBATIM>{verbatimEnd} ECHO; /*printf("VSP");*/ yy_pop_state();

({whitespace})*"\\par"({whitespace})+ addLines(2);  if(YY_START == FORMAT) yy_pop_state(); /*spacing*/
({whitespace})*"\\medskip"({whitespace})+ addLines(2); if(YY_START == FORMAT) yy_pop_state(); /*spacing*/
({whitespace})*"\\bigskip"({whitespace})+  addLines(3); if(YY_START == FORMAT) yy_pop_state(); /*spacing*/
({whitespace})*"\\pagebreak"("["[0-9]"]")?({whitespace})+ addLines(4); if(YY_START == FORMAT) yy_pop_state(); /*spacing*/
({whitespace})*"\\fixnobreak" addLines(1); if(YY_START == FORMAT) yy_pop_state();  /* spacing */


  /* We need to remember that there can be preserve states inside other preserve states, we must ensure that we push and pop as appropriate otherwise we will mismatch and not be able to enter or leave states appropriately, use test t9 to check on changes to this with the push and pop print statements turned on */
<INITIAL,PRESERVESTATE>{preserveStart} /*printf("PS");*/ ECHO; yy_push_state(PRESERVESTATE); /*Special environments*/
<INITIAL,PRESERVESTATE>({mathStart})(\r?\n){0,1} /*printf("MS");*/ yy_push_state(BRACEMATH);
<VERBATIM,BRACEMATH,PRESERVESTATE>(\r?\n) printf("\n");
<PRESERVESTATE>{preserveEnd} ECHO; /*printf("PSP");*/ yy_pop_state();
<BRACEMATH>(\r?\n)({mathEnd})(\r?\n) printf("\n"); /*printf("MSP");*/ yy_pop_state();
<BRACEMATH>({mathEnd}) /*printf("MSP");*/ yy_pop_state();

{word}/(\r?\n) /*printf("F");*/ ECHO; curLines=0; yy_push_state(FORMAT);  /*Everywhere else we reformat*/
{word}/("\\par"|"\\medskip"|"\\bigskip"|"\\pagebreak"("["[0-9]"]")?) ECHO; curLines=0; 
<FORMAT>(\r?\n) printf(" "); curLines=0; /*printf("P1");*/ yy_pop_state();
<FORMAT>(\r?\n)/({mathStart}|{preserveStart}|{verbatimStart}) printf("\n"); /*printf("P2");*/ yy_pop_state(); /*Everything else*/
<FORMAT>(\r?\n)/"\\end" printf("\n");
<FORMAT>(\r?\n)(" "|\t)*(\r?\n) curLines=0; addLines(2);  /*printf("P3");*/ yy_pop_state(); //paragraph test */
<<EOF>> curLines=0; addLines(1); return 0;

\r?\n printf("\n"); /*Just in case*/
. ECHO; curLines=0;
%%

int addLines(int more) {
int i=0;
int min = 0;
if (curLines <= maxLines) {
min = maxLines<more? maxLines : more;
//printf("///adding %d newlines.\n", min);
for (i=curLines ; i<min; i++) {
printf("\n");
}
curLines += min;
}
}

