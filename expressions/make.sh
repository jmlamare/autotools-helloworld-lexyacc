yacc -d expressions.parser.y  -b expressions.parser
mv     expressions.parser.tab.h expressions-expressions.parser.h 
mv     expressions.parser.tab.c expressions-expressions.parser.c 
lex -o expressions-expressions.lexer.c expressions.lexer.l
gcc -o expressions expressions-expressions.parser.c expressions-expressions.lexer.c -ly -ll

