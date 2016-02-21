%{
double vbltable[26];
%}
%union {
	double	dval;
	int	vblno;
}

%token <vblno> NAME
%token <dval> NUMBER
%type <dval> expression;
%type <dval> factor;
%type <dval> primary;
%%
statement_list:	statement '\n'
	|	statement_list statement '\n'
	;

statement:	NAME '=' expression	{ vbltable[$1] = $3; }
	|	expression		{ printf("= %g\n", $1); }
	;

expression:	expression '+' factor	{ $$ = $1 + $3; }
	|	expression '-' factor	{ $$ = $1 - $3; }
	|	factor			{ $$ = $1; }
	;

factor:		factor '*' primary	{ $$ = $1 * $3; }
	|	factor '/' primary	{ if($3==0.0) { yyerror("divide by zero"); } else { $$ = $1 / $3; } }
	|	primary			{ $$ = $1; }
	;

primary:	'(' expression ')'	{ $$ =  $2; }
	|	'-' primary		{ $$ = -$2; }
	|	NUMBER			{ $$ =  $1; }
	|	NAME			{ $$ = vbltable[$1]; }
	;
%%

