#ifndef VARS_H_
#define VARS_H_

#include <gmp.h>

typedef struct _var_t   var_t;
struct _var_t
{
    char  *name;
    mpz_t n;
    var_t *prev, *next;
};

void    var_init(void);
void    var_destroy(void);

void    var_set(char *, mpz_t);
void    var_get(char *, mpz_t);

#endif