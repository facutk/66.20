#include <math.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <stdio.h>
#include <stdint.h>

#include <param.h>

static void pthreads_plot(void);
extern void generic_plot(param_t *);
extern void sse_plot(param_t *);

int x_res = 4;		/* Ancho de imagen por defecto. */
int y_res = 1;		/* Alto de imagen, por defecto. */

//float upper_left_re = +0.2795;	/* Extremo superior izquierzo (re). */
//float upper_left_im = -0.0075;	/* Extremo superior izquierzo (im). */
//float lower_right_re = +0.2845;	/* Extremo inferior derecho (re). */
//float lower_right_im = -0.0125;	/* Extremo inferior derecho (im). */

float upper_left_re = -0.65;
float lower_right_re = -0.55;
float lower_right_im = +0.20;
float upper_left_im = +0.30;

size_t nthreads = 1;            /* Cantidad de threads de cómputo. */
void (*plot)(param_t *);

typedef struct {
	const char *name;
	void (*plot)(param_t *);
} METHOD;

int
main(int argc, char * const argv[], char * const envp[])
{
    plot = generic_plot;
    pthreads_plot();
    

    plot = sse_plot;
    pthreads_plot();

    return 0;
}

struct thread_info {
	pthread_t tid;
	param_t parms;
};

static void
pthreads_plot(void)
{
	struct thread_info *tinfo;
	param_t parms;
	uint8_t *u8;
	size_t y0;
	size_t yd;
	size_t tn;
	size_t y;
	size_t x;

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
	parms.y0 = 0;
	parms.y1 = y_res;

	parms.bitmap = u8 = malloc(sizeof(uint8_t) * x_res * y_res);

	tinfo = malloc(sizeof(struct thread_info) * nthreads);

	y0 = 0;
	yd = y_res / nthreads;

	for (tn = 0; tn < nthreads; ++tn) {
		memcpy(&tinfo[tn].parms, &parms, sizeof(parms));
		tinfo[tn].parms.y0 = y0;
		tinfo[tn].parms.y1 = tn < nthreads - 1
		                     ? (y0 += yd)
		                     : (y_res);

		pthread_create(&tinfo[tn].tid, 
		               NULL, 
		               (void *)plot,
		               &tinfo[tn].parms);
	}

	for (tn = 0; tn < nthreads; ++tn) 
		pthread_join(tinfo[tn].tid, NULL);
	

	for (y = 0; y < parms.y_res; ++y)
        {
            for (x = 0; x < parms.x_res; ++x) {

                    printf( "%3d ", (unsigned) *u8++);

            }
            //printf("\n");
	}
        printf("\n");

	/* Deallocate memory. */
	if (parms.bitmap != NULL)
		free(parms.bitmap), parms.bitmap = NULL;
}
