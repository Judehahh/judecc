#include <assert.h>
#include <stdio.h>

extern FILE *yyin;
extern int yyparse(char **);

int main(int argc, const char *argv[]) {
    assert(argc == 2);
    const char *input = argv[1];

    yyin = fopen(input, "r");
    assert(yyin);

    char *ast;
    int ret = yyparse(&ast);
    assert(!ret);

    printf("ast: %s\n", ast);
    return 0;
}
