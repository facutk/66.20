#include "CuTest.h"
#include <stdio.h>

void test_parse_width_gets_1_returns_1(CuTest *tc) {
    double expected = 1;
    double actual;
    double delta = 0.00001;
    char param[] = "1";

    int result = parse_width( param, &actual );

    CuAssertDblEquals(tc, expected, actual, delta);
}

void test_parse_width_gets_10_returns_10(CuTest *tc) {
    double expected = 10;
    double actual;
    double delta = 0.00001;
    char param[] = "10";

    int result = parse_width( param, &actual );

    CuAssertDblEquals(tc, expected, actual, delta);
}

void test_parse_width_gets_A_halts(CuTest *tc) {

    char param[] = "A";
    double returned;

    int expected = 1;
    int actual = parse_width( param, &returned );

    CuAssertIntEquals(tc, expected, actual);
}

void test_parse_width_gets_empty_halts(CuTest *tc) {

    char param[] = "";
    double returned;

    int expected = 1;
    int actual = parse_width( param, &returned );

    CuAssertIntEquals(tc, expected, actual);
}

void test_parse_width_gets_negative_halts(CuTest *tc) {

    char param[] = "-1";
    double returned;

    int expected = 1;
    int actual = parse_width( param, &returned );

    CuAssertIntEquals(tc, expected, actual);
}

CuSuite* parse_opt_tests_get_suite() {
    CuSuite* suite = CuSuiteNew();
    SUITE_ADD_TEST(suite, test_parse_width_gets_1_returns_1);
    SUITE_ADD_TEST(suite, test_parse_width_gets_10_returns_10);
    SUITE_ADD_TEST(suite, test_parse_width_gets_A_halts );
    SUITE_ADD_TEST(suite, test_parse_width_gets_empty_halts );
    SUITE_ADD_TEST(suite, test_parse_width_gets_negative_halts );

    return suite;
}
