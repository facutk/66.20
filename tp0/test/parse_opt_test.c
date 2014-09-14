#include "CuTest.h"
#include <stdio.h>

void test_parse_width_gets_1_returns_1(CuTest *tc) {
    double expected = 1;
    double actual;
    double delta = 0.00001;
    char param[] = "1";

    int result = parseWidth( param, &actual );

    CuAssertDblEquals(tc, expected, actual, delta);
}

CuSuite* parse_opt_tests_get_suite() {
    CuSuite* suite = CuSuiteNew();
    SUITE_ADD_TEST(suite, test_parse_width_gets_1_returns_1);
    return suite;
}
