CC = gcc
CFLAGS ?= -Wall
OFLAGS ?= -O3
LDFLAGS ?= -static
DIRINC = include

all: tp0

tests: test/run_tests.c test/parse_opt_test.c include/CuTest.c src/parse_opt.c src/default_values.h
	$(CC) -I$(DIRINC) test/run_tests.c test/parse_opt_test.c src/default_values.h include/CuTest.c src/parse_opt.c -o $@
	./$@

tp0: src/main.c src/parse_opt.c src/mandelbrot.c src/default_values.h
	$(CC) src/mandelbrot.c src/parse_opt.c src/main.c $(OFLAGS) -o $@

clean:
	rm tp0 tests
