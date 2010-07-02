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
lBrace ([[:blank:]])*"{"([[:blank:]])*
rBrace ([[:blank:]])*"}"
verbatim ("verbatim"|"Verbatim")
verbatimStart "\\begin"{lBrace}{verbatim}{rBrace}
verbatimEnd "\\end"{lBrace}{verbatim}{rBrace}

%x VERBATIM
%%


"\\\\" ECHO; /*protect newlines*/
"\\~" ECHO; /*protect escaped tilde*/

("\\/") /*spacing added only due to text being italic, not needed */
("\\,"|"\\:"|"\\;"|"\\ "|"\\!"|"~") printf(" "); /*remove some special spacing cf tabbing in s2*/
("\\quad"|"\\qquad")/({nan}) printf(" "); /*special spacing*/
"\\linebreak"("["[0-9]"]")? /* spacing */
"\\baselineskip" /*spacing change, eat it up */
"\\text{ }" printf(" "); /*inftyreader*/
"{\\_}" printf("\\_"); /*inftyreader*/

("\\displaystyle"" "{0,1})/({nan}) /*this is irrelevant, is going to leave a space problem?*/
"\\underline"/({nan}) printf("\\ul"); /* Easier to read? */
"\\overline"/({nan}) printf("\\ol"); /* Easier to read? */
"\\ast"/({nan}) printf("*"); /*maths*/
"\\ndash"/({nan}) printf("--"); /* ndash is -- and mdash is --- */
"\\mdash"/({nan}) printf("---"); /* ndash is -- and mdash is --- */
("\\ne"|"\\neq"|"\\not=")/({nan}) printf("!="); /*maths*/
("\\le"|"\\leq"|"\\leqq")/({nan}) printf("<="); /*maths*/
("\\ge"|"\\geq"|"\\geqq")/({nan}) printf(">="); /*maths*/
"\\ll"/({nan}) printf("<<"); /*maths*/
"\\gg"/({nan}) printf(">>"); /*maths*/
"\\pm"/({nan}) printf("+-"); /*maths*/
"\\mp"/({nan}) printf("-+"); /*maths*/
"\\mid"/({nan}) printf("|"); /*maths*/
"\\Vert"/({nan}) printf("||"); /*maths*/
"\\bigr)" printf(")"); /*maths*/
"\\bigl(" printf("("); /*maths*/
"\\left"("."?)/({nan}) /*. place holder for size match*/ 
"\\right"("."?)/({nan}) 
("\\to"|"\\rightarrow"|"\\leadsto"|"\\mapsto")/({nan}) fprintf(yyout,"->"); /*maths */
"\\leftarrow"/({nan}) printf("<-"); /*maths */
"\\longrightarrow"/({nan}) printf("-->"); /*maths*/
"\\longleftarrow"/({nan}) printf("<--"); /*maths*/
"\\Leftarrow"/({nan}) printf("<=="); /*maths */
"\\Rightarrow"/({nan}) printf("==>"); /*maths */
"\\Longrightarrow"/({nan}) printf("-==>"); /*maths*/
"\\xLongrightarrow{}" printf("-==>"); /*maths*/
"\\Longleftarrow"/({nan}) printf("<==-"); /*maths*/
"\\xLongleftarrow{}" printf("<==-"); /*maths*/
"\\leftrightarrow"/({nan}) printf("<->"); /*maths*/
"\\Leftrightarrow"/({nan}) printf("<=>"); /*maths */
"\\ldots"/({nan}) printf("..."); /*maths*/
"\\vee"/({nan}) printf("\\lor"); /*maths */
"\\wedge"/({nan}) printf("\\land"); /*maths */
"\\bigvee"/({nan}) printf("\\biglor"); /*maths */
"\\bigwedge"/({nan}) printf("\\bigland"); /*maths */
'' printf("\"");
`` printf("\"");
"\\"("vfill"|"eject"|"bye"|"noindent"|"sloppy"|"fussy"|"raggedright"|"raggedleft")/({nan}) /*eating up*/

{verbatimStart} ECHO; yy_push_state(VERBATIM);
<VERBATIM>{verbatimEnd} ECHO; yy_pop_state();

"\\begin"{lBrace}"center"{rBrace}
"\\end"{lBrace}"center"{rBrace}

\r?\n printf("\n"); /*Just in case*/
<VERBATIM>(\r?\n) printf("\n"); /*Just in case*/
