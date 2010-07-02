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
common ("rm"|"it"|"textit"|"bf"|"em"|"emph"|"tt"|"tiny"|"scriptsize"|"small"|"normalsize"|"large"|"Large"|"LARGE"|"huge"|"Huge"|"sl"|"sf"|"narrower"|"centerline"|"bigbold"|"sc"|"bfseries"|"textsc"|"itshape")
preBrace ("centerline"|"mathrm"|"mbox"|"hbox"|"mathbf"|"textbf"|"text"|({common}))(" "*)"{"
postBrace ({common})
mathChar ("cal"|"scr"|"frak"|"bb")
removecommon ("hspace""*"?|"vspace""*"?|"index"|"indexas"|"usepackage"|"cline")
verbatim ("verbatim"|"Verbatim")
lbrace ([[:blank:]])*"{"([[:blank:]])*
rbrace ([[:blank:]])*"}"
lbraceb "{"([[:blank:]])*

verbatimStart "\\begin"{lbrace}{verbatim}{rbrace}
verbatimEnd "\\end"{lbrace}{verbatim}{rbrace}

%x VERBATIM mathAlphabet
%s brace removeMyPreBrace removeMyPostBrace text removeMe removeMyContentsBrace mathLetter
%%
	int braceDepth = 0;
        char *whichMath;

(" ")?"\\parbox{"(([0-9]|".")*("in"|"cm"))?"}{" yy_push_state(removeMyPreBrace); /*remove parboxes */

 /*New stuff, this should NOT be used with any mathenvironment where spaces should be preserved*/
 /* Scarily, \mathcal{R^{n}} will not error in LaTeX but will not print R^n in the PDF*/
 /* Despite the lowercase cal's not being defined there is no error and this will produce a*/
 /* symbol that visually is nothing to do with the input... this information will be lost */
("{\\"("math")?)/(({mathChar})" ") yy_push_state(mathAlphabet);
("\\"("math")?)/(({mathChar})"{") yy_push_state(mathAlphabet);
("\\"("math")?)/(({mathChar})" ") yy_push_state(mathLetter);
<mathAlphabet,mathLetter>({mathChar})/(" "|"{")  whichMath = strdup(yytext); input();
<mathLetter>([A-Za-z]) printf("\\%s",whichMath); ECHO; yy_pop_state();
<mathLetter>([0-9]) if (strcmp(whichMath,"bb") == 0) printf("\\%s",whichMath); ECHO; yy_pop_state();
<mathAlphabet>([A-Za-z]) printf("\\%s",whichMath); ECHO; 
<mathAlphabet>([0-9]) if (strcmp(whichMath,"bb") == 0) printf("\\%s",whichMath); ECHO;
<mathAlphabet>"}" if(braceDepth==0) yy_pop_state(); else {ECHO; braceDepth--;}
<mathAlphabet>"{" braceDepth++; ECHO;
 /*End new stuff */

"\\"({preBrace}) yy_push_state(removeMyPreBrace); /*needs to be replaced by a space*/

("_"){lbrace}"\\"({postBrace})(" ") printf("_{"); yy_push_state(brace);
("^"){lbrace}"\\"({postBrace})(" ") printf("^{"); yy_push_state(brace);
{lbraceb}"\\"({postBrace})(" ") yy_push_state(removeMyPostBrace);

"\\"({common})(" ")
"\\"({removecommon}){lbrace} yy_push_state(removeMyContentsBrace);
<removeMyContentsBrace>([^"}""{"])
<removeMyContentsBrace>"{" yy_push_state(removeMyContentsBrace);

"\\{" ECHO; /*These braces are specifically allowed not to match*/
"\\}" ECHO; /*These braces are specifically allowed not to match*/

"{" ECHO; yy_push_state(brace);/*Ensures we get rid of closing braces e.g \it */
"}" if (YY_START == brace) ECHO; yy_pop_state();

{verbatimStart} ECHO; yy_push_state(VERBATIM);
<VERBATIM>{verbatimEnd} ECHO; yy_pop_state();

\r?\n printf("\n"); /*Just in case*/
<VERBATIM>(\r?\n) printf("\n"); /*Just in case*/

