#include "CuTest.h"
#include <stdio.h>
    
CuSuite* parse_opt_tests_get_suite();

void run_all_tests(void) {
    CuString *output = CuStringNew();
    CuSuite* suite = CuSuiteNew();
    
    CuSuiteAddSuite(suite, parse_opt_tests_get_suite() );
    CuSuiteRun(suite);
    CuSuiteSummary(suite, output);
    CuSuiteDetails(suite, output);
    printf("%s\n", output->buffer);
}

int main(void) {
    disable_error_output();
    run_all_tests();
    return 0;
}
