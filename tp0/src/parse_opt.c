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

int parse_width( char * param, double * result ) {
    double width;
    int scanned = sscanf( param, "%lf", &width );
    *result = width;
    return 0;
}
