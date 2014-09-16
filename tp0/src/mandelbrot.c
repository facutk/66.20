/*
===========================================================================
 Name        : mandelbrot.c
 Author      : Tkaczyszyn, Facundo
 Version     : 1.0
 Description : 66.20 TP0 - Mandelbrot, Version 1.0
===========================================================================
 */

#include <stdio.h>
#include <math.h>

int mandelbrot( int res_x,
                int res_y,
                double c_re,
                double c_im,
                double width,
                double height,
                FILE * output ) {

    const int    max_it = 255;
    const double escape_radius = 2;

    int it_x;
    int it_y;
    double c_x;
    double c_y;
    double c_x_min = c_re - ( width / 2 );
    double c_y_min = c_im - ( height/ 2 );

    double px_width  = ( width  )/res_x;
    double px_height = ( height )/res_y;

    double z_x, z_y;
    double z_x_sq, z_y_sq;

    int it;

    double er_sq = escape_radius*escape_radius;

    // PGM header
    fprintf( output,"P2\n%d\n%d\n%d\n", res_x, res_y, max_it );

    // iterate over the coordinates and write the data
    for( it_y = res_y; it_y > 0 ; it_y-- ) {
        c_y = c_y_min + it_y * px_height;
        if( fabs( c_y ) < px_height / 2 ) c_y = 0.0;
        for( it_x = 0 ; it_x < res_x ; it_x++ ) {         
            c_x    = c_x_min + it_x * px_width;
            z_x    = c_x;
            z_y    = c_y;
            z_x_sq = z_x * z_x;
            z_y_sq = z_y * z_y;
            for ( it = 0; it < max_it && ((z_x_sq + z_y_sq )< er_sq ); it++) {
                z_y    = 2 * z_x * z_y + c_y;
                z_x    = z_x_sq - z_y_sq + c_x;
                z_x_sq = z_x * z_x;
                z_y_sq = z_y * z_y;
            };
            fprintf( output, "%3d ", it);
        }
        fprintf( output, "\n");
    }
    return 0;
}

