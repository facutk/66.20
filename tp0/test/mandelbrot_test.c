#include "CuTest.h"
#include <stdio.h>

/* 
 * mandelbrot test cases
 * */

void test_mandelbrot_01(CuTest *tc) {

    char expected[] = 
    "P2\n"
    "1\n"
    "1\n"
    "255\n"
    "255 \n";

    char actual[4096];

    myfprintf_init_buffer();
    mandelbrot(  1, // resolution x
                 1, // resolution y
               0.0, // center real
               0.0, // center imaginary
               4.0, // width
               4.0, // height
              NULL  // output NULL writes to internal buffer
                );

    myfprintf_cpy( actual );

    CuAssertStrEquals(tc, expected, actual);
}

void test_mandelbrot_02(CuTest *tc) {

    char expected[] = 
    "P2\n"
    "10\n"
    "10\n"
    "255\n"
    "  0   0   0   0   0   0   0   0   0   0 \n"
    "  0   0   0   1   1   1   1   1   0   0 \n"
    "  0   0   1   2   2   2   1   1   1   0 \n"
    "  0   2   2   3   5  17   3   1   1   1 \n"
    "  0   2   6   6 255 255   8   2   1   1 \n"
    "  0 255 255 255 255 255   6   2   1   1 \n"
    "  0   2   6   6 255 255   8   2   1   1 \n"
    "  0   2   2   3   5  17   3   1   1   1 \n"
    "  0   0   1   2   2   2   1   1   1   0 \n"
    "  0   0   0   1   1   1   1   1   0   0 \n";

    char actual[4096];

    myfprintf_init_buffer();
    mandelbrot( 10, // resolution x
                10, // resolution y
               0.0, // center real
               0.0, // center imaginary
               4.0, // width
               4.0, // height
              NULL  // output NULL writes to internal buffer
                );

    myfprintf_cpy( actual );

    CuAssertStrEquals(tc, expected, actual);
}

CuSuite* mandelbrot_tests_get_suite() {
    CuSuite* suite = CuSuiteNew();

    // mandelbrot test cases
    SUITE_ADD_TEST(suite, test_mandelbrot_01);
    SUITE_ADD_TEST(suite, test_mandelbrot_02);

    return suite;
}
