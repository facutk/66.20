CC = gcc
CFLAGS ?= -Wall
OFLAGS ?= -O3
LDFLAGS ?= -static
DIRINC = include

all: tp0

tests: test/runTests.c test/ParseOptTest.c include/CuTest.c src/ParseOpt.c
	$(CC) -I$(DIRINC) test/runTests.c test/ParseOptTest.c include/CuTest.c src/ParseOpt.c -o $@
	./$@

tp0: src/main.c src/ParseOpt.c
	$(CC) src/main.c src/ParseOpt.c $(OFLAGS) -o $@

clean:
	rm tp0 tests
