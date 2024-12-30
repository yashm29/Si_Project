flex lexical.l
bison -d syntaxique.y
gcc lex.yy.c syntaxique.tab.c -lfl -ly -o ISIL2024.exe