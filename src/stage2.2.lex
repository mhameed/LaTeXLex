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
int curTabs=0;
%}
word ([[:blank:]]*[[:alnum:]]+[[:blank:]]*[,"."]*[" "]*)+
lbrace ([[:blank:]])*"{"([[:blank:]])*
rbrace ([[:blank:]])*"}"
/*first attempt to deal with tabbing environments sensibly */
/*there are now two ideas of tabbing going on, a true tabbing environment written by a human, which we have not dealt with yet and the tabbing provided by InftyEditor which we are in adding. The latter does not take place in any specific environment */
tabbingenvs ("tabbing") 
verbatim ("verbatim"|"Verbatim")
verbatimStart "\\begin"{lbrace}{verbatim}{rbrace}
verbatimEnd "\\end"{lbrace}{verbatim}{rbrace}

tabStart "\\begin"{lbrace}{tabbingenvs}{rbrace}
tabEnd "\\end"{lbrace}{tabbingenvs}{rbrace}

%x VERBATIM TABSTATE TABCOUNT
%%

{verbatimStart} ECHO; yy_push_state(VERBATIM);
<VERBATIM>{verbatimEnd} ECHO; yy_pop_state();

 /* InftyEditor tabs we collect sequences of these and summarise*/
"[Tab]" curTabs++; yy_push_state(TABCOUNT);
<TABCOUNT>"[Tab]" curTabs++;
 /* It is not clear what the correct behaviour is when tabs have spaces in between*/
 /*<TABCOUNT>(" ")/("[Tab]") ECHO; */
<TABCOUNT>(" ") printTabs(); yy_pop_state();
<TABCOUNT>(.|(\r?\n)) printTabs(); ECHO; yy_pop_state();



 /* Symbols which have special meaning in a tabbing environment are: */ 
 /* \= \> \+ \- \< \' \` \kill \pushtabs \poptabs \a=' \a'' \a`' */
 /* Firstly, these symbols should not be removed by stage1.0 */
 /* Secondly, we need to know if any of the symbols have special */
 /* meaning outside of the tabbing environment and what that meaning */ 
 /* is. We deal with that for now and preserve the tabbing */
 /* environment until we have worked out what to do with it. */
 /* It would need to be preserved here and in stage3.0 */

{tabStart} ECHO; yy_push_state(TABSTATE); /*Attempting tabs */
<TABSTATE>(\r?\n) printf("\n"); 
  /* If we ever know how to, we treat the special tab symbols in here */
<TABSTATE>{tabEnd} ECHO; yy_pop_state();

 /* The only one which we have any evidence for being used outside */
 /* the tabbing environment is \> which is used by nnv in a TeX */
 /* document where it appears to just add a space and so: */
("\\>"" "{0,1}) printf(" "); 

\r?\n printf("\n"); /*Just in case*/
<VERBATIM>(\r?\n) printf("\n"); /*Just in case*/

%%

int printTabs(){
if(curTabs > 0)
printf("(%d tab) ",curTabs); 
curTabs = 0;
}
