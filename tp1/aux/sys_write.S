#include <mips/regdef.h>
#include <sys/syscall.h>

                                      # Layout del stack
                                      # 24 a2   count
                                      # 20 a1   buf
                                      # 16 a0   fd
                                      # --
                                      # 12 -    padding
                                      # 8  ra
                                      # 4  $fp
                                      # 0  gp

#define SW_STACK_SIZE   16
#define SW_A2           24
#define SW_A1           20
#define SW_A0           16
#define SW_RA           8
#define SW_FP           4
#define SW_GP           0

        .text
        .align  2

        .globl  sys_write
        .ent    sys_write
sys_write:

    .frame  $fp, SW_STACK_SIZE, ra
    .set    noreorder
    .cpload t9
    .set    reorder
    subu    sp, sp, SW_STACK_SIZE
    .cprestore SW_GP

    sw      gp,  SW_GP(sp)
    sw      $fp, SW_FP(sp)
    move    $fp, sp
    sw      ra,  SW_RA($fp)

    sw      a0,  SW_A0($fp)
    sw      a1,  SW_A1($fp)
    sw      a2,  SW_A2($fp)

    li      v0,  SYS_write            # ver dentro de <sys/syscall.h>.
    lw      a0,  SW_A0($fp)           # a0: standard output file descriptor.
    lw      a1,  SW_A1($fp)           # a1: data pointer.
    lw      a2,  SW_A2($fp)           # a2: data length.
    syscall
    
    bgez    v0,  SW_RETURN            # Si vuelve del syscall sin errores
                                      # salgo normalmente

    li      v0,  SYS_write            # Si no salio normalmente
    li      a0,  2                    # Imprimo mensaje de error por stderr
    la      a1,  ioerror       
    li      a2,  11        

    li      v0,  SYS_exit             # exit(1)
    li      a0,  1
    syscall

SW_RETURN:

    lw      ra,  SW_RA(sp)            # Destruimos el frame.
    move    sp,  $fp
    lw      $fp, SW_FP(sp)
    lw      gp,  SW_GP(sp)
    addu    sp,  sp, SW_STACK_SIZE

    jr      ra
    .end        sys_write                 # Retorno

    .rdata
ioerror:
    .asciiz "i/o error.\n"

