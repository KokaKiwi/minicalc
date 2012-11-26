%{
#include <stdlib.h>
#include <stdio.h>
#include <gmp.h>
#include "config.h"
%}

%union
{
    char    *str;
    mpz_t   n;
}

%start input

%token END STOP
%token ABS SQRT

%token <str> IDENTIFIER
%token <n> NUMBER

%type <n> expr term factor function

%%

input
    :   /* Empty */
    |   input statement
    ;

statement
    :   END
    |   expr END                { gmp_printf("%Zd\n", $1); mpz_clear($1); }
    |   STOP                    { return (0); }
    ;

expr
    :   term                    { mpz_init_set($$, $1); mpz_clear($1); }
    |   expr '+' term           { mpz_init($$); mpz_add($$, $1, $3); mpz_clears($1, $3, NULL); }
    |   expr '-' term           { mpz_init($$); mpz_sub($$, $1, $3); mpz_clears($1, $3, NULL); }
    |   IDENTIFIER '=' expr     { var_set($1, $3); mpz_init($$); mpz_set($$, $3); mpz_clear($3); }
    ;

term
    :   factor                  { mpz_init_set($$, $1); mpz_clear($1); }
    |   term '*' factor         { mpz_init($$); mpz_mul($$, $1, $3); mpz_clears($1, $3, NULL); }
    |   term '/' factor         { mpz_init($$); mpz_tdiv_q($$, $1, $3); mpz_clears($1, $3, NULL); }
    |   term '%' factor         { mpz_init($$); mpz_tdiv_r($$, $1, $3); mpz_clears($1, $3, NULL); }
    |   term '&' factor         { mpz_init($$); mpz_and($$, $1, $3); mpz_clears($1, $3, NULL); }
    |   term '|' factor         { mpz_init($$); mpz_ior($$, $1, $3); mpz_clears($1, $3, NULL); }
    ;

factor
    :   NUMBER                  { mpz_init_set($$, $1); mpz_clear($1); }
    |   IDENTIFIER              { mpz_init($$); var_get($1, $$); }
    |   '(' expr ')'            { mpz_init_set($$, $2); mpz_clear($2); }
    |   function                { mpz_init_set($$, $1); mpz_clear($1); }
    |   '-' factor              { mpz_init($$); mpz_neg($$, $2); mpz_clear($2); }
    ;

function
    :   ABS '(' expr ')'        { mpz_init($$); mpz_abs($$, $3); mpz_clear($3); }
    |   SQRT '(' expr ')'       { mpz_init($$); mpz_sqrt($$, $3); mpz_clear($3); }
    ;

%%

int    yyerror(char *s)
{
    // fprintf(stderr, "%s\n", s);
    return (0);
}
