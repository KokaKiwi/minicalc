#include <stdlib.h>
#include <string.h>
#include <gmp.h>
#include "vars.h"

var_t   *vars;

void        var_add(var_t *var)
{
    vars->prev->next = var;
    var->prev = vars->prev;
    vars->prev = var;
    var->next = vars;
}

var_t       *var_create(char *name, mpz_t n)
{
    var_t   *var;

    var = malloc(sizeof(var_t));
    if (var != NULL)
    {
        if (name != NULL)
        {
            var->name = strdup(name);
        }
        else
        {
            var->name = NULL;
        }
        mpz_init(var->n);
        if (n != NULL)
        {
            mpz_set(var->n, n);
        }
        var->prev = var->next = var;
    }
    return (var);
}

void        var_init()
{
    vars = var_create(NULL, NULL);
}

void        var_remove(var_t *var)
{
    var->prev->next = var->next;
    var->next->prev = var->prev;
    var->next = var->prev = var;
}

void        var_delete(var_t *var)
{
    var_remove(var);
    mpz_clear(var->n);
    free(var->name);
    free(var);
}

void        var_destroy()
{
    var_t   *cur;
    var_t   *next;

    cur = vars->next;
    while (cur != vars)
    {
        next = cur->next;
        var_delete(cur);
        cur = next;
    }
    var_delete(vars);
}

var_t       *var_search(const char *name)
{
    var_t   *cur;

    cur = vars->next;
    while (cur != vars)
    {
        if (strcmp(cur->name, name) == 0)
        {
            return (cur);
        }
        cur = cur->next;
    }
    return (NULL);
}

void        var_set(char *name, mpz_t n)
{
    var_t   *var;

    var = var_search(name);
    if (var == NULL)
    {
        var = var_create(name, n);
        var_add(var);
    }
    else
    {
        mpz_set(var->n, n);
    }
    free(name);
}

void        var_get(char *name, mpz_t n)
{
    var_t   *var;

    var = var_search(name);
    if (var != NULL)
    {
        mpz_set(n, var->n);
    }
    free(name);
}
