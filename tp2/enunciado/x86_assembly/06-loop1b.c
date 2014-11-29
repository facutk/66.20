/*
 * 06-loop1b.c
 *
 * Similar a loop1a.c, s�lo que en este caso evitamos cargar los
 * registros expl�citamente, usando restricciones espec�ficas de
 * registros.
 *
 * $Date: 2008/06/10 18:50:01 $
 */

#include <stdio.h>

int
main(int argc, char * const argv[])
{
	int i;
	int j;

	for (i = 0; i < 10; ++i) {
		__asm__ volatile (
			"mull %1 \n\t"
		: "=a" (j)
		: "0" (i)
		: "cc", "edx"
		);
		printf("%d^2 = %d\n", i, j);
	}

	return 0;
}
