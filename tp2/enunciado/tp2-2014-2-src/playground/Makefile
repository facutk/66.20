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
HDRS    = param.h
SRCS	= generic_plot.c sse_plot.c main.c
PROG	= playground
AUXLIBS = 

$(PROG): $(SRCS) $(HDRS)
	$(CC) $(CFLAGS) -o $@ $(SRCS) $(SYSLIBS)
	./$@
