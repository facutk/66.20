CC = gcc
CXX = g++
CFLAGS ?= -Wall
OFLAGS ?= -O3
LDFLAGS ?= -static

DIRINC = include
DIRTEST = test
DIRSRC = src

_DEPSINC = CuTest.c
DEPSINC = $(patsubst %,$(DIRINC)/%,$(_DEPSINC))

_DEPSMAIN = main.c
DEPSMAIN = $(patsubst %,$(DIRSRC)/%,$(_DEPSMAIN))

_DEPSTEST = runTests.c ParseOptTest.c 
DEPSTEST = $(patsubst %,$(DIRTEST)/%,$(_DEPSTEST))

_DEPSSRC = ParseOpt.c
DEPSSRC = $(patsubst %,$(DIRSRC)/%,$(_DEPSSRC))

all: unitests tp0

unitests: $(DEPSTEST) $(DEPSINC) $(DEPSSRC)
	$(CC) -I$(DIRINC) $(DEPSTEST) $(DEPSINC) $(DEPSSRC) -o $@
	./$@
	rm $@

tp0: $(DEPSMAIN) $(DEPSSRC)
	$(CC) $(DEPSSRC) $(DEPSMAIN) $(OFLAGS) -o $@

clean:
	rm tp0
