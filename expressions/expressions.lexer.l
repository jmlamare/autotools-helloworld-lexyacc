%{
#include "expressions-expressions.parser.h"
#include <math.h>
extern double vbltable[26];
extern int yyparse (void);
%}

%%
([0-9]+|([0-9]*\.[0-9]+)([eE][-+]?[0-9]+)?)	{ yylval.dval = atof(yytext); return NUMBER; }
[a-z]						{ yylval.vblno = yytext[0] - 'a'; return NAME; }
"$"						{ return 0; }
[ \t]						;
\n	|
.						{ return yytext[0]; }
%%


