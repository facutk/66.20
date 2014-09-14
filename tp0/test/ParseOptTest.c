#include "CuTest.h"
#include <stdio.h>

void testOneEqOne(CuTest *tc) {
    int actual = genOne();
    int expected = 1;
    CuAssertIntEquals(tc, expected, actual);
}

CuSuite* StrUtilGetSuite() {
    CuSuite* suite = CuSuiteNew();
    SUITE_ADD_TEST(suite, testOneEqOne);
    return suite;
}
