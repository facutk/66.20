#include <mips/regdef.h>
#include <sys/syscall.h>

    # void header_pgm( int fd, int x_res, int y_res, int shades )
    #
    # Imprimo numero segun a0
    #
    # Layout del stack
    # ABA 44 a3   shades
    #     40 a2   y_res
    #     36 a1   x_res
    #     32 a0   fd
    # --  -- --   -------
    # SRA 28 ra
    #     24 $fp
    #     20 gp
    #     16 --   padding
    # ABA 12 --   padding
    #     8  a2
    #     4  a1
    #     0  a0

#define HP_STACK_SIZE   32

#define HP_A3           44
#define HP_A2           40
#define HP_A1           36
#define HP_A0           32

#define HP_RA           28
#define HP_FP           24
#define HP_GP           20

    .text
    .align  2

    .globl  header_pgm
    .ent    header_pgm
header_pgm:

    .frame  $fp, HP_STACK_SIZE, ra
    .set    noreorder
    .cpload t9
    .set    reorder
    subu    sp, sp, HP_STACK_SIZE
    .cprestore HP_GP

    sw      gp,  HP_GP(sp)
    sw      $fp, HP_FP(sp)
    move    $fp, sp
    sw      ra,  HP_RA($fp)

    sw      a0,  HP_A0($fp)
    sw      a1,  HP_A1($fp)
    sw      a2,  HP_A2($fp)
    sw      a3,  HP_A3($fp)


    lw      a0,  HP_A0($fp)           # a0: standard output file descriptor.
    la      a1,  HP_P2                # a1: data pointer.
    li      a2,  3                    # a2: data length.
    la      t9,  sys_write            # encapsulo SYS_write para manejar errores
    jalr    t9

    lw      a0,  HP_A0($fp)           # a0: fd
    lw      a1,  HP_A1($fp)           # a1: x_res
    la      t9,  write_sint           # write_sint( fd, x_res )
    jalr    t9
    
    lw      a0,  HP_A0($fp)           # a0: fd
    lw      a1,  HP_A2($fp)           # a1: y_res
    la      t9,  write_sint           # write_sint( fd, y_res )
    jalr    t9
    
    lw      a0,  HP_A0($fp)           # a0: fd
    lw      a1,  HP_A3($fp)           # a1: shades
    la      t9,  write_sint           # write_sint( fd, shades )
    jalr    t9


    lw      ra,  HP_RA(sp)            # Destruimos el frame.
    move    sp,  $fp
    lw      $fp, HP_FP(sp)
    lw      gp,  HP_GP(sp)
    addu    sp,  sp, HP_STACK_SIZE

    jr      ra
    .end    header_pgm                # Retorno

    .rdata
HP_P2:
    .asciiz "P2\n"
