%option noyywrap
%option nounput
%option noinput

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "sysy.tab.h"

char *strdup(const char *s) {
    int n = strlen(s) + 1;
    char *d = malloc(n);
    if(d) strcpy(d, s);
    return d;
}
%}

WhiteSpace      [ \t\r\n]*
LineComment     "//".*

/* identifier */
Identifier      [a-zA-Z_][a-zA-Z0-9_]*

/* literal */
Decimal         [1-9][0-9]*
Octal           0[0-7]*
Hexadecimal     0[xX][0-9a-fA-F]+

%%

{WhiteSpace}    { /* ignore */ }
{LineComment}   { /* ignore */ }

"int"           { return INT; }
"return"        { return RETURN; }

{Identifier}    { yylval.str_val = strdup(yytext); return IDENT; }

{Decimal}       { yylval.int_val = atoi(yytext); return INT_CONST; }
{Octal}         { yylval.int_val = atoi(yytext); return INT_CONST; }
{Hexadecimal}   { yylval.int_val = atoi(yytext); return INT_CONST; }

.               { return yytext[0]; }

%%
