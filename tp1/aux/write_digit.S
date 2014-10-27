#include <mips/regdef.h>
#include <sys/syscall.h>

    # void write_digit( int fd, int digit )
    #
    # Imprimo numero segun a0
    #
    # Layout del stack
    # ABA 44 --   padding
    #     40 --   padding
    #     36 a1
    #     32 a0   
    # --  -- --   -------
    # SRA 28 ra
    #     24 $fp
    #     20 gp
    #     16 --   padding
    # ABA 12 --   padding
    #     8  a2
    #     4  a1
    #     0  a0

#define WD_STACK_SIZE   32

#define WD_A1           36
#define WD_A0           32

#define WD_RA           28
#define WD_FP           24
#define WD_GP           20

    .text
    .align  2

    .globl  write_digit
    .ent    write_digit
write_digit:

    .frame  $fp, WD_STACK_SIZE, ra
    .set    noreorder
    .cpload t9
    .set    reorder
    subu    sp, sp, WD_STACK_SIZE
    .cprestore WD_GP

    sw      gp,  WD_GP(sp)
    sw      $fp, WD_FP(sp)
    move    $fp, sp
    sw      ra,  WD_RA($fp)

    sw      a0,  WD_A0($fp)
    sw      a1,  WD_A1($fp)


    lw      a0,  WD_A0($fp)           # a0: standard output file descriptor.
    la      a1,  WD_NUMBERS           # a1: data pointer.
    lw      t0,  WD_A1($fp)
    add     a1,  a1, t0
    li      a2,  1                    # a2: data length.
    la      t9,  sys_write            # encapsulo SYS_write para manejar errores
    jalr    t9
    
    lw      ra,  WD_RA(sp)            # Destruimos el frame.
    move    sp,  $fp
    lw      $fp, WD_FP(sp)
    lw      gp,  WD_GP(sp)
    addu    sp,  sp, WD_STACK_SIZE

    jr      ra
    .end    write_digit               # Retorno

    .rdata
WD_NUMBERS:
    .asciiz "0123456789"
