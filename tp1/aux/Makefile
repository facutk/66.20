PROGS  = tp1-mips
CFLAGS = -g -Wall -O0

all: $(PROGS)
	:

tp1-mips: main.c sys_write.S write_digit.S write_sint.S header_pgm.S mips32_plot.S calc_brightness.S
	gcc $(CFLAGS) -o $@ $>

clean:
	rm -f $(PROGS) *.so *.o *.a *.core

