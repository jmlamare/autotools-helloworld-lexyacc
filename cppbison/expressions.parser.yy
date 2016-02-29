%skeleton "lalr1.cc" /* -*- C++ -*- */
%require "3.0.2"
%defines
%define parser_class_name {ExprParser}
%define api.token.constructor
%define api.value.type variant
%define parse.assert
%code requires
{ 
  #include <iostream>
  #include <fstream>
  #define YY_NULLPTR 0
  struct ExprScanner;
}
%define parse.trace
%define parse.error verbose
%code {
  double vbltable[26];
  extern yy::ExprParser::symbol_type yylex(ExprScanner *scanner) ;
}
%param { ExprScanner *scanner } // The parsing context
%define api.token.prefix {TOK_}

%token          END;
%token <int>    NAME
%token <double> NUMBER
%type  <double> expression;
%type  <double> factor;
%type  <double> primary;
%printer { yyoutput << $$; } <*>;
%initial-action {
  //TODO 
};
%%
%start statements;

statements:	statement_list END

statement_list:	statement '\n'
	|	statement_list statement '\n'
	;

statement:	NAME '=' expression	{ vbltable[$1] = $3; }
	|	expression		{ std::cout << " =" << $1 << std::endl; }
	;

expression:	expression '+' factor	{ $$ = $1 + $3; }
	|	expression '-' factor	{ $$ = $1 - $3; }
	|	factor			{ $$ = $1; }
	;

factor:		factor '*' primary	{ $$ = $1 * $3; }
	|	factor '/' primary	{ $$ = $1 / $3; }
	|	primary			{ $$ = $1; }
	;

primary:	'(' expression ')'	{ $$ =  $2; }
	|	'-' primary		{ $$ = -$2; }
	|	NUMBER			{ $$ =  $1; }
	|	NAME			{ $$ = vbltable[$1]; }
	;
%%

void yy::ExprParser::error (const std::string& msg) {
    std::cerr << msg << std::endl;
}
