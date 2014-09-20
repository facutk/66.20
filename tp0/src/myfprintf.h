/*
===========================================================================
 Name        : myfprintf.h
 Author      : Tkaczyszyn, Facundo
 Version     : 1.0
 Description : myfprintf header
===========================================================================
 */

#ifndef MYFPRINTF_H
#define MYFPRINTF_H

#include <stdio.h>
#define BUFFER_SIZE 4096

char g_buffer[ BUFFER_SIZE ];

void myfprintf(FILE * output, const char *format, ...);
void myfprintf_init_buffer();
void myfprintf_cpy( char * destination );

#endif
