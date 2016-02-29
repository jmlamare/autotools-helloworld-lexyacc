%option c++
%option noyywrap
%option nounput
%option noinput
%option outfile="expressions.scanner.cc"
%option prefix="Expr"
%option stack

%{
#include <cmath>
#include <iostream>
#include "expressions.parser.hh"

#define YY_DECL yy::ExprParser::symbol_type ExprScanner::yyscan()
#define yyterminate() return yy::ExprParser::make_END();

class ExprScanner : public yyFlexLexer {
public:
  ExprScanner( FLEX_STD istream* yin = 0, FLEX_STD ostream* yout = 0 ) : yyFlexLexer(yin,yout) {};
  yy::ExprParser::symbol_type yyscan();
};

%}

%%

([0-9]+|([0-9]*\.[0-9]+)([eE][-+]?[0-9]+)?)	{ return yy::ExprParser::make_NUMBER(atof(yytext)); }
[ \t]						/* Ignore whitespaces */ ;
[a-z]						{ return yy::ExprParser::make_NAME(yytext[0]-'a'); }
<<EOF>>                                         { return yy::ExprParser::make_END(); }
\n						{ return static_cast<yy::ExprParser::token_type>(*yytext); }
.						{ return static_cast<yy::ExprParser::token_type>(*yytext); }

%%

int yyFlexLexer::yylex() {
  LexerError( "yyFlexLexer::yylex invoked but %option yyclass used" );
  return 0;
}

extern yy::ExprParser::symbol_type yylex(ExprScanner *scanner) {
  return scanner->yyscan();
}

extern int main(int argc, char **argv) {
  ExprScanner scanner(&std::cin, &std::cout);
  yy::ExprParser parser(&scanner);
  return parser.parse();  
}
