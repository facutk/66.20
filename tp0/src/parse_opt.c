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
    if ( scanned == 1 ) {
        if ( width > 0 ) {
            *result = width;
            return 0;
        }
    }
    fprintf( stderr, "fatal: invalid width specification.\n" );
    return 1;
}
