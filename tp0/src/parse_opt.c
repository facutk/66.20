/*
 ==========================================================================
 Name        : ParseOpt.c
 Author      : Tkaczyszyn, Facundo
 Version     : 1.0
 Description : Utility module to handle command line user interface
 ==========================================================================
 */

#include <stdio.h>
#include "default_values.h"

int parseWidth( char * param, double * result ) {
    *result = default_width;
    return 0;
}
