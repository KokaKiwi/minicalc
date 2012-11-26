#include <gmp.h>
#include "vars.h"
#include "parser.h"

void    yyparse(void);
int     yylex_destroy(void);

int main(int argc, char **argv)
{
    var_init();
    yyparse();
    var_destroy();
    yylex_destroy();
    return (0);
}