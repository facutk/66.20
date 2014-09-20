/*
 ==========================================================================
 Name        : myfprintf.c
 Author      : Tkaczyszyn, Facundo
 Version     : 1.0
 Description : Wrapper around vsprintf.
               This is used to unit test the mandelbrot module.
 ==========================================================================
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include "myfprintf.h"

void myfprintf(FILE * output, const char *format, ...) {
    char t_buffer[ 128 ] ;
    va_list args;
    va_start (args, format);

    vsprintf (t_buffer, format, args);
    strcat(g_buffer, t_buffer) ;

    va_end (args);
}

void myfprintf_init_buffer(){
    g_buffer[0] = 0;
}

void myfprintf_cpy( char * destination ){
    strcpy( destination, g_buffer );
}

