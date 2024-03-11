%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex();
void yyerror(char **ast, const char *s);

%}

%parse-param { char **ast }

// yylval
%union {
  char *str_val;
  int int_val;
}

// lexer 返回的所有 token 种类的声明
// 注意 IDENT 和 INT_CONST 会返回 token 的值, 分别对应 str_val 和 int_val
%token INT RETURN
%token <str_val> IDENT
%token <int_val> INT_CONST

// 非终结符的类型定义
%type <str_val> FuncDef FuncType Block Stmt Number

%%

CompUnit
  : FuncDef {
    *ast = strdup($1);
  }
  ;

FuncDef
  : FuncType IDENT '(' ')' Block {
    char *type = $1;
    char *ident = $2;
    char *block = $5;
    char *result = malloc(strlen(type) + strlen(ident) + strlen(block) + 5);
    sprintf(result, "%s %s() %s", type, ident, block);
    $$ = result;
  }
  ;

FuncType
  : INT {
    $$ = "int";
  }
  ;

Block
  : '{' Stmt '}' {
    char *stmt = $2;
    char *result = malloc(strlen(stmt) + 5);
    sprintf(result, "{ %s }", stmt);
    $$ = result;
  }
  ;

Stmt
  : RETURN Number ';' {
    char *number = $2;
    char *result = malloc(strlen(number) + 10);
    sprintf(result, "return %s;", number);
    $$ = result;
  }
  ;

Number
  : INT_CONST {
    char *result = malloc(32);
    sprintf(result, "%d", $1);
    $$ = result;
  }
  ;

%%

void yyerror(char **ast, const char *s) {
  fprintf(stderr, "error: %s\n", s);
}

