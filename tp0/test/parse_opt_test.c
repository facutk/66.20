#include "CuTest.h"
#include <stdio.h>

/* 
 * parse_width() tests
 * */
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

/* 
 * parse_height() tests
 * */
void test_parse_height_gets_1_returns_1(CuTest *tc) {
    double expected = 1;
    double actual;
    double delta = 0.00001;
    char param[] = "1";

    int result = parse_height( param, &actual );

    CuAssertDblEquals(tc, expected, actual, delta);
}

void test_parse_height_gets_10_returns_10(CuTest *tc) {
    double expected = 10;
    double actual;
    double delta = 0.00001;
    char param[] = "10";

    int result = parse_height( param, &actual );

    CuAssertDblEquals(tc, expected, actual, delta);
}

void test_parse_height_gets_A_halts(CuTest *tc) {

    char param[] = "A";
    double returned;

    int expected = 1;
    int actual = parse_height( param, &returned );

    CuAssertIntEquals(tc, expected, actual);
}

void test_parse_height_gets_empty_halts(CuTest *tc) {

    char param[] = "";
    double returned;

    int expected = 1;
    int actual = parse_height( param, &returned );

    CuAssertIntEquals(tc, expected, actual);
}

void test_parse_height_gets_negative_halts(CuTest *tc) {

    char param[] = "-1";
    double returned;

    int expected = 1;
    int actual = parse_height( param, &returned );

    CuAssertIntEquals(tc, expected, actual);
}

/* 
 * parse_resolution() tests
 * */
void test_parse_resolution_gets_empty_halts(CuTest *tc) {
    int expected = 1;
    int res_x;
    int res_y;
    char param[] = "";

    int actual = parse_resolution( param, &res_x, &res_y );

    CuAssertIntEquals(tc, expected, actual);
}

void test_parse_resolution_gets_16x12_returns_16x12(CuTest *tc) {
    int expected_x = 16;
    int expected_y = 12;
    int actual_x;
    int actual_y;
    char param[] = "16x12";

    int actual = parse_resolution( param, &actual_x, &actual_y );

    CuAssertIntEquals(tc, expected_x, actual_x);
    CuAssertIntEquals(tc, expected_y, actual_y);
}

void test_parse_resolution_gets_negative_halts(CuTest *tc) {
    int res_x;
    int res_y;
    char param[] = "-16x12";

    int expected = 1;
    int actual = parse_resolution( param, &res_x, &res_y );

    CuAssertIntEquals(tc, expected, actual);
}

/* 
 * parse_center() tests
 * */
void test_parse_center_gets_empty_halts(CuTest *tc) {
    double c_re;
    double c_im;
    char param[] = "";

    int expected = 1;
    int actual = parse_center( param, &c_re, &c_im );

    CuAssertIntEquals(tc, expected, actual);
}

void test_parse_center_gets_1_2i_returns_1_2(CuTest *tc) {
    double actual_c_re;
    double actual_c_im;
    char param[] = "1+2i";
    double delta = 0.00001;

    double expected_c_re = 1;
    double expected_c_im = 2;
    int result = parse_center( param, &actual_c_re, &actual_c_im );

    CuAssertDblEquals(tc, expected_c_re, actual_c_re, delta);
    CuAssertDblEquals(tc, expected_c_im, actual_c_im, delta);
}

void test_parse_center_gets_1_2i_neg_returns_1_2_neg(CuTest *tc) {
    double actual_c_re;
    double actual_c_im;
    char param[] = "-1-2i";
    double delta = 0.00001;

    double expected_c_re = -1;
    double expected_c_im = -2;
    int result = parse_center( param, &actual_c_re, &actual_c_im );

    CuAssertDblEquals(tc, expected_c_re, actual_c_re, delta);
    CuAssertDblEquals(tc, expected_c_im, actual_c_im, delta);
}

/* 
 * parse_output() tests
 * */
void test_parse_output_gets_empty_halts(CuTest *tc) {
    FILE * output;
    char param[] = "";

    int expected = 1;
    int actual = parse_output( param, &output );

    CuAssertIntEquals(tc, expected, actual);
}

void test_parse_output_gets_dash_returns_stdout(CuTest *tc) {
    FILE * actual_output;
    char param[] = "-";

    FILE * expected_output = stdout;
    int result = parse_output( param, &actual_output );

    CuAssertPtrEquals(tc, expected_output, actual_output);
}

void test_parse_output_gets_impossible_halts(CuTest *tc) {
    FILE * output;
    char param[] = "/tmp";

    int expected = 1;
    int actual = parse_output( param, &output );

    CuAssertIntEquals(tc, expected, actual);
}

CuSuite* parse_opt_tests_get_suite() {
    CuSuite* suite = CuSuiteNew();

    // parse_width()
    SUITE_ADD_TEST(suite, test_parse_width_gets_1_returns_1);
    SUITE_ADD_TEST(suite, test_parse_width_gets_10_returns_10);
    SUITE_ADD_TEST(suite, test_parse_width_gets_A_halts );
    SUITE_ADD_TEST(suite, test_parse_width_gets_empty_halts );
    SUITE_ADD_TEST(suite, test_parse_width_gets_negative_halts );

    // parse_height()
    SUITE_ADD_TEST(suite, test_parse_height_gets_1_returns_1);
    SUITE_ADD_TEST(suite, test_parse_height_gets_10_returns_10);
    SUITE_ADD_TEST(suite, test_parse_height_gets_A_halts );
    SUITE_ADD_TEST(suite, test_parse_height_gets_empty_halts );
    SUITE_ADD_TEST(suite, test_parse_height_gets_negative_halts );

    // parse_resolution()
    SUITE_ADD_TEST(suite, test_parse_resolution_gets_empty_halts );
    SUITE_ADD_TEST(suite, test_parse_resolution_gets_16x12_returns_16x12 );
    SUITE_ADD_TEST(suite, test_parse_resolution_gets_negative_halts );

    // parse_center()
    SUITE_ADD_TEST(suite, test_parse_center_gets_empty_halts );
    SUITE_ADD_TEST(suite, test_parse_center_gets_1_2i_returns_1_2 );
    SUITE_ADD_TEST(suite, test_parse_center_gets_1_2i_neg_returns_1_2_neg );

    // parse_output()
    SUITE_ADD_TEST(suite, test_parse_output_gets_empty_halts);
    SUITE_ADD_TEST(suite, test_parse_output_gets_dash_returns_stdout);
    SUITE_ADD_TEST(suite, test_parse_output_gets_impossible_halts);

    return suite;
}
