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

"0x"([0-9a-fA-F]+)      {
                            char *number = strndup(yytext + 2, strlen(yytext) - 2);
                            mpz_init_set_str(yylval.n, number, 16);
                            free(number);
                            return (NUMBER);
                        }
[0-9]+                  {
                            mpz_init_set_str(yylval.n, yytext, 10);
                            return (NUMBER);
                        }

"-"                     { return ('-'); }
"+"                     { return ('+'); }
"*"                     { return ('*'); }
"/"                     { return ('/'); }
"%"                     { return ('%'); }
"|"                     { return ('|'); }
"&"                     { return ('&'); }

"("                     { return ('('); }
")"                     { return (')'); }

"="                     { return ('='); }

";"                     { return (END); }
"\n"                    { return (END); }
<<EOF>>                 { return (STOP); }

"abs"                   { return (ABS); }
"sqrt"                  { return (SQRT); }

"quit"                  { return (STOP); }

[a-zA-Z_][a-zA-Z0-9_]*  { yylval.str = strdup(yytext); return (IDENTIFIER); }

.                       { ECHO; yyerror("unexpected character."); }

%%

int     yywrap(void)
{
    return (1);
}
