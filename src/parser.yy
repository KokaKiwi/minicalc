%{
#include <stdlib.h>
#include <stdio.h>
#include <gmp.h>
#include "config.h"
%}

%union
{
    char    *str;
    int     i;
    mpz_t   n;
}

%start input

%token END STOP
%token ABS SQRT RAND
%token LE_OP GE_OP EQ_OP NE_OP

%token <str> IDENTIFIER
%token <n> NUMBER

%type <n> expr term factor function
%type <i> cmp_expr

%%

input
    :   /* Empty */
    |   input statement
    ;

statement
    :   END
    |   expr END                            { gmp_printf("%Zd\n", $1); var_set("result", $1); mpz_clear($1); }
    |   error END
    |   STOP                                { return (0); }
    ;

expr
    :   term                                { mpz_init_set($$, $1); mpz_clear($1); }
    |   expr '+' term                       { mpz_init($$); mpz_add($$, $1, $3); mpz_clears($1, $3, NULL); }
    |   expr '-' term                       { mpz_init($$); mpz_sub($$, $1, $3); mpz_clears($1, $3, NULL); }
    |   cmp_expr '?' expr ':' expr          {
                                                if ($1)
                                                {
                                                    mpz_init_set($$, $3);
                                                }
                                                else
                                                {
                                                    mpz_init_set($$, $5);
                                                }
                                                mpz_clears($3, $5, NULL);
                                            }
    |   IDENTIFIER '=' expr                 { var_set($1, $3); free($1); mpz_init($$); mpz_set($$, $3); mpz_clear($3); }
    ;

term
    :   factor                              { mpz_init_set($$, $1); mpz_clear($1); }
    |   term '*' factor                     { mpz_init($$); mpz_mul($$, $1, $3); mpz_clears($1, $3, NULL); }
    |   term '/' factor                     { mpz_init($$); mpz_tdiv_q($$, $1, $3); mpz_clears($1, $3, NULL); }
    |   term '%' factor                     { mpz_init($$); mpz_tdiv_r($$, $1, $3); mpz_clears($1, $3, NULL); }
    |   term '&' factor                     { mpz_init($$); mpz_and($$, $1, $3); mpz_clears($1, $3, NULL); }
    |   term '|' factor                     { mpz_init($$); mpz_ior($$, $1, $3); mpz_clears($1, $3, NULL); }
    ;

factor
    :   NUMBER                              { mpz_init_set($$, $1); mpz_clear($1); }
    |   IDENTIFIER                          { mpz_init($$); var_get($1, $$); free($1); }
    |   '(' expr ')'                        { mpz_init_set($$, $2); mpz_clear($2); }
    |   function                            { mpz_init_set($$, $1); mpz_clear($1); }
    |   '-' factor                          { mpz_init($$); mpz_neg($$, $2); mpz_clear($2); }
    |   '+' factor                          { mpz_init_set($$, $2); mpz_clear($2); }
    ;

function
    :   ABS '(' expr ')'                    { mpz_init($$); mpz_abs($$, $3); mpz_clear($3); }
    |   SQRT '(' expr ')'                   { mpz_init($$); mpz_sqrt($$, $3); mpz_clear($3); }
    |   RAND '(' ')'                        { mpz_init($$); mpz_random($$, 16); }
    ;

cmp_expr
    :   '(' expr '<' expr ')'               { $$ = mpz_cmp($2, $4) < 0 ? 1 : 0; mpz_clears($2, $4, NULL); }
    |   '(' expr '>' expr ')'               { $$ = mpz_cmp($2, $4) > 0 ? 1 : 0; mpz_clears($2, $4, NULL); }
    |   '(' expr LE_OP expr ')'             { $$ = mpz_cmp($2, $4) <= 0 ? 1 : 0; mpz_clears($2, $4, NULL); }
    |   '(' expr GE_OP expr ')'             { $$ = mpz_cmp($2, $4) >= 0 ? 1 : 0; mpz_clears($2, $4, NULL); }
    |   '(' expr EQ_OP expr ')'             { $$ = mpz_cmp($2, $4) == 0 ? 1 : 0; mpz_clears($2, $4, NULL); }
    |   '(' expr NE_OP expr ')'             { $$ = mpz_cmp($2, $4) != 0 ? 1 : 0; mpz_clears($2, $4, NULL); }
    ;

%%

int    yyerror(char *s)
{
    fprintf(stderr, "%s\n", s);
    return (0);
}
