#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#define BUFFER_SIZE 4096

char g_buffer[ BUFFER_SIZE ];

void myfprintf(FILE * output, const char *format, ...) {
    char t_buffer[ 128 ] ;
    va_list args;
    va_start (args, format);

    if ( output == NULL ) {
        vsprintf (t_buffer, format, args);
        strcat(g_buffer, t_buffer) ;
    } else {
        vfprintf( output, format, args );
    }
    
    va_end (args);
}

void myfprintf_init_buffer(){
    g_buffer[0] = 0;
}

void myfprintf_cpy( char * destination ){
    strcpy( destination, g_buffer );
}

