%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <gmp.h>
#include "parser.h"
#include "config.h"
%}

%%

[ \t\r]+                { }

[0-9]+                  { mpz_init(yylval.n); mpz_set_str(yylval.n, yytext, 10); return (NUMBER); }

"-"                     { return ('-'); }
"+"                     { return ('+'); }
"*"                     { return ('*'); }
"/"                     { return ('/'); }
"%"                     { return ('%'); }
"("                     { return ('('); }
")"                     { return (')'); }
"="                     { return ('='); }

";"                     { return (END); }
"\n"                    { return (END); }
<<EOF>>                 { return (END); }

"abs"                   { return (ABS); }

"quit"                  { return (QUIT); }

[a-zA-Z_][a-zA-Z0-9_]*  { yylval.str = strdup(yytext); return (IDENTIFIER); }

.                       { ECHO; yyerror("unexpected character."); }

%%

int     yywrap(void)
{
    return (1);
}
