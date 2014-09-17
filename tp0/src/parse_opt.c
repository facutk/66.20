/*
 ==========================================================================
 Name        : parse_opt.c
 Author      : Tkaczyszyn, Facundo
 Version     : 1.0
 Description : Utility module to handle command line user interface
 ==========================================================================
 */

#include <stdio.h>
#include <string.h>
#include <getopt.h>

const char msg_invalid_width[]      = "invalid width specification.";
const char msg_invalid_height[]     = "invalid height specification.";
const char msg_invalid_resolution[] = "invalid resolution specification.";
const char msg_invalid_center[]     = "invalid center specification.";
const char msg_output_error[]       = "Output file error.";

const char* const op_cortas = "r:c:w:H:o:hV";

const struct option op_largas[] = {
    { "resolution", required_argument, NULL, 'r' },
    { "center",     required_argument, NULL, 'c' },
    { "width",      required_argument, NULL, 'w' },
    { "height",     required_argument, NULL, 'H' },
    { "output",     required_argument, NULL, 'o' },
    { "help",       no_argument,       NULL, 'h' },
    { "version",    no_argument,       NULL, 'V' },
    { NULL,         no_argument,       NULL, 0 }
};

int print_stderr = 1;

void disable_error_output() {
    print_stderr = 0;
}

void print_error(const char * message ) {
    if ( print_stderr )
        fprintf( stderr, "fatal: %s\n", message );
}

int parse_width( char * param, double * result ) {
    double width;
    int scanned = sscanf( param, "%lf", &width );
    if ( scanned == 1 ) {
        if ( width > 0 ) {
            *result = width;
            return 0;
        }
    }
    print_error( msg_invalid_width );
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
    print_error( msg_invalid_height );
    return 1;
}

int parse_resolution( char * param, int * res_x, int * res_y ) {
    int _res_x;
    int _res_y;

    int scanned = sscanf( param, "%dx%d", &_res_x, &_res_y );
    if ( scanned == 2 ) {
        if ( ( _res_x > 0) && (_res_y > 0) ) {
            *res_x = _res_x; 
            *res_y = _res_y; 
            return 0;
        }
    }
    print_error( msg_invalid_resolution );
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
    print_error( msg_invalid_center );
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
    
    print_error( msg_output_error );
    return 1;
}

void print_help( char * binary_name ) {
	printf(
"Usage:\n"
"  %s [options]\n"
"\n"
"Options:\n"
"  -r, --resolution (WxH)       Image resolution (default: 640x480).\n"
"  -c, --center (a+bi)          Complex plane center (default: 0+0i).\n"
"  -w, --width (w)              Complex plane width (default: 4).\n"
"  -H, --height (h)             Complex plane height (default: 4).\n"
"  -o, --output [destination]   Path to output file (PGM format).\n"
"                               If [destionation] is -, outputs to stdout\n"
"  -h, --help                   Print this message and quit.\n"
"  -V, --version                Print version and quit.\n"
"\n",
	binary_name );
}

void print_version() {
  printf("66.20 TP0 - Mandelbrot, Version 1.0\n");
}

int parse_opts( int argc,
                char * const * argv,
                int * res_x,
                int * res_y,
                double * c_re,
                double * c_im,
                double * width,
                double * height,
                FILE ** output ) {
    
    int output_defined = 0;
    int result;

    // getopt does not print over stderr
    opterr = 0;
    
    // every argument processed
    int next_opt = 0;

    while (1) {

        next_opt = getopt_long( argc,
                                argv,
                                op_cortas,
                                op_largas,
                                NULL);

        if (next_opt == -1) {
            break;
        }

        switch (next_opt) {

            case 'r': {
                if ( parse_resolution( optarg,
                                       res_x,
                                       res_y ) > 0 )
                    return 1;
                break;
            }

            case 'c': {
                if ( parse_center( optarg,
                                   c_re,
                                   c_im ) > 0 )
                    return 1;
                break;
            }

            case 'w': {
                if( parse_width( optarg,
                                 width ) > 0 )
                    return 1;
                break;
            }

            case 'H': {
                if( parse_height( optarg,
                                  height ) > 0 )
                    return 1;
                break;
            }

            case 'o': {
                if( parse_output( optarg,
                                  output ) == 0 ) {
                    output_defined = 1;
                } else {
                    return 1;
                }
                break;
            }

            case 'h': {
                print_help( argv[0] );
                return 1;
                break;
            }

            case 'V': {
                print_version();
                return 1;
                break;
            }

            default: {
                print_help( argv[0] );
                return 1;
                break;
            }
        }
    }

    if ( !output_defined ) return 1;

    return 0;
}

