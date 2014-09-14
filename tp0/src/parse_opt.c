/*
 ==========================================================================
 Name        : ParseOpt.c
 Author      : Tkaczyszyn, Facundo
 Version     : 1.0
 Description : Utility module to handle command line user interface
 ==========================================================================
 */

#include <stdio.h>
#include <string.h>
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

int parse_height( char * param, double * result ) {
    double height;
    int scanned = sscanf( param, "%lf", &height );
    if ( scanned == 1 ) {
        if ( height > 0 ) {
            *result = height;
            return 0;
        }
    }
    fprintf( stderr, "fatal: invalid height specification.\n" );
    return 1;
}

int parse_resolution( char * param, double * res_x, double * res_y ) {
    double _res_x;
    double _res_y;

    int scanned = sscanf( param, "%lfx%lf", &_res_x, &_res_y );
    if ( scanned == 2 ) {
        if ( ( _res_x > 0) && (_res_y > 0) ) {
            *res_x = _res_x; 
            *res_y = _res_y; 
            return 0;
        }
    }
    fprintf( stderr, "fatal: invalid resolution specification.\n" );
    return 1;
}

int parse_center( char * param, double * c_re, double * c_im ) {
    double _c_re;
    double _c_im;
    char _c_im_sign;

    int scanned = sscanf( param, "%lf%c%lfi" , &_c_re, &_c_im_sign, &_c_im );
    if ( scanned == 3 ) {

        if (_c_im_sign == '-') 
            _c_im = _c_im * -1;
        *c_re = _c_re;
        *c_im = _c_im;

        return 0;
    }
    fprintf( stderr, "fatal: invalid center specification.\n" );
    return 1;
}

int parse_output( char * param, FILE ** output ) {
    FILE * _output = 0;

    if ( strcmp(param, "-") == 0 ) {
        _output = stdout;
    } else {
        _output = fopen( param, "wb" );
    }

    if ( _output ) {
        *output = _output;
        return 0;
    }
    
    fprintf( stderr, "fatal: Output file error.\n" );
    return 1;
}

