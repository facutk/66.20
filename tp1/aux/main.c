#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include "param.h"

extern void mips32_plot(param_t *);

static void plot(void) {

    int x_res = 4;                /* Ancho de imagen por defecto. */
    int y_res = 3;                /* Alto de imagen, por defecto. */
    float upper_left_re = -0.65;  /* Extremo superior izquierzo (re). */
    float upper_left_im = +0.30;  /* Extremo superior izquierzo (im). */
    float lower_right_re = -0.55; /* Extremo inferior derecho (re). */
    float lower_right_im = +0.20; /* Extremo inferior derecho (im). */
    FILE *output;

    output = stdout;

    param_t parms;

    memset(&parms, 0, sizeof(parms));
    parms.UL_re = upper_left_re;
    parms.UL_im = upper_left_im;
    parms.LR_re = lower_right_re;
    parms.LR_im = lower_right_im;
    parms.d_re = (lower_right_re - upper_left_re) / x_res;
    parms.d_im = (upper_left_im - lower_right_im) / y_res;
    parms.x_res = x_res;
    parms.y_res = y_res;
    parms.shades = 255;
    parms.fp = output;


    mips32_plot(&parms);
}

int
main(int argc, char * const argv[])
{
    plot();
    return 0;
}

