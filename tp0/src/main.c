/*
===========================================================================
 Name        : main.c
 Author      : Tkaczyszyn, Facundo
 Version     : 1.0
 Description : 66.20 TP0 - Mandelbrot, Version 1.0
===========================================================================
 */

#include <stdio.h>
#include "default_values.h"

int main(int argc, char** argv) {
    int    res_x  = default_res_x;
    int    res_y  = default_res_y;
    double width  = default_width;
    double height = default_height;
    double c_re   = default_c_re;
    double c_im   = default_c_im;
    FILE * output;

    int parse_result =  parse_opts( argc,
                                    argv,
                                    &res_x,
                                    &res_y,
                                    &c_re,
                                    &c_im,
                                    &width,
                                    &height,
                                    &output );

    if ( parse_result == 0 ) {
        mandelbrot( res_x,
                    res_y,
                    c_re,
                    c_im,
                    width,
                    height,
                    output,
                    fprintf );
        return 0;
    }
    return 1;

}

