# Do not edit -- this file documents how this program was built for your machine.
SYSTYPE	= LINUX3
SYSLIBS	= -lpthread -msse
CC	= gcc $(WARN) -g -DUSE_SSE_ASSEMBLY
OPT	= -O
DEBUG	= -g
EXPORT	= AUXLIBS='' CCARGS='-g -DUSE_SSE_ASSEMBLY' OPT='-O' DEBUG='-g'
WARN	= -Wall
SHELL	= /bin/sh
DEFS    = -I. -D$(SYSTYPE)
CFLAGS  = $(DEBUG) $(OPT) $(DEFS)
OPTS	= 'CC=$(CC)'
HDRS    = debug.h defs.h mygetopt.h param.h
SRCS	= generic_plot.c sse_plot.c main.c mygetopt_long.c
PROG	= tp2-2014-2-bin
AUXLIBS = 

$(PROG): $(SRCS) $(HDRS)
	$(CC) $(CFLAGS) -ggdb -o $@ $(SRCS) $(SYSLIBS)
	time ./$@ -o /dev/null -r 1024x768 -m generic -n 8
	time ./$@ -o /dev/null -r 1024x768 -m generic -n 8 -p
	#./$@ -o - -r 4x4 -m generic
	#./$@ -o - -r 4x4 -m sse

update: $(PROG)
	:

makefiles Makefiles:
	(echo "# Do not edit -- this file documents how this program was built for your machine."; $(SHELL) makedefs) >makedefs.tmp
	set +e;                                \
	if cmp makedefs.tmp makedefs.out; then \
	    rm makedefs.tmp;                   \
	else                                   \
	    mv makedefs.tmp makedefs.out;      \
	fi >/dev/null 2>/dev/null
	rm -f Makefile; (cat makedefs.out Makefile.in) >Makefile
