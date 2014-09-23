CC = gcc
CFLAGS ?= -Wall
OFLAGS ?= -O3
LDFLAGS ?= -static
DIRINC = include

all: tp0

tests: test/run_tests.c test/parse_opt_test.c include/CuTest.c src/parse_opt.c src/myfprintf.h src/default_values.h src/myfprintf.c src/mandelbrot.c test/mandelbrot_test.c
	$(CC) -I$(DIRINC) test/run_tests.c test/parse_opt_test.c include/CuTest.c src/parse_opt.c src/myfprintf.c src/mandelbrot.c test/mandelbrot_test.c -o $@
	./$@

tp0: src/main.c src/parse_opt.c src/myfprintf.c src/mandelbrot.c src/default_values.h
	$(CC) src/myfprintf.c src/mandelbrot.c src/parse_opt.c src/main.c $(OFLAGS) -o $@

clean:
	rm tp0 tests
