#include <mips/regdef.h>
#include <sys/syscall.h>

    # void write_sint( int fd, int number )
    #
    # Descompongo el int en digitos y los mando a imprimir
    #
    # Layout del stack
    # ABA 60 --   padding
    #     56 --   padding
    #     52 a1   number
    #     48 a0   fd
    # --  -- --   -------
    # SRA 44 ra
    #     40 $fp
    #     36 gp
    #     32 --   padding
    # LTA 28 t3   h_digit
    #     24 t2   m_digit
    #     20 t1   l_digit
    #     16 t0   rem
    # ABA 12 --   padding
    #     8  --   padding
    #     4  --   padding
    #     0  a0

#define WS_STACK_SIZE   48

#define WS_A1           52
#define WS_A0           48

#define WS_RA           44
#define WS_FP           40
#define WS_GP           36

#define WS_H_DIGIT      28
#define WS_M_DIGIT      24
#define WS_L_DIGIT      20
#define WS_REM          16


    .text
    .align  2

    .globl  write_sint
    .ent    write_sint
write_sint:

    .frame  $fp, WS_STACK_SIZE, ra
    .set    noreorder
    .cpload t9
    .set    reorder
    subu    sp, sp, WS_STACK_SIZE
    .cprestore WS_GP

    sw      ra,  WS_RA(sp)
    sw      $fp, WS_FP(sp)
    sw      gp,  WS_GP(sp)
    move    $fp, sp

    sw      a0,  WS_A0($fp)
    sw      a1,  WS_A1($fp)

    lw      t0,  WS_A1($fp)           # Me guardo el valor a0 en otra variable
    sw      t0,  WS_REM($fp)          # temporal para trabajar

    li      t1,  0                    # Inicializo las variables con 0
    sw      t1,  WS_L_DIGIT($fp)
    li      t2,  0
    sw      t2,  WS_M_DIGIT($fp)
    li      t3,  0
    sw      t3,  WS_H_DIGIT($fp)


    lw      t0,  WS_REM($fp)          # Busco el digito mas bajo y lo guardo
    li      t4,  10                   # Haciendo rem entre el numero
    rem     t1,  t0, t4               # y 10.
    sw      t1,  WS_L_DIGIT($fp)      # Lo guardo en su lugar
    divu    t0,  t0, t4               # REM/=10
    sw      t0,  WS_REM($fp)
    
    lw      t0,  WS_REM($fp)          # Busco el digito del medio y lo guardo
    li      t4,  10                   # Haciendo rem entre el numero
    rem     t2,  t0, t4               # y 10.
    sw      t2,  WS_M_DIGIT($fp)      # Lo guardo en su lugar
    divu    t0,  t0, t4               # REM/=10
    sw      t0,  WS_REM($fp)
    
    lw      t0,  WS_REM($fp)          # Busco el digito mas grande y lo guardo
    li      t4,  10                   # Haciendo rem entre el numero
    rem     t3,  t0, t4               # y 10.
    sw      t3,  WS_H_DIGIT($fp)      # Lo guardo en su lugar
    

    lw      t3,  WS_H_DIGIT($fp)      # Si el numero mas alto es un 0
    beqz    t3,  WS_WRITE_M_DIGIT     # Lo salteo, no lo imprimo

    lw      a0,  WS_A0($fp)           # a0: standard output file descriptor.
    lw      a1,  WS_H_DIGIT($fp)      # a1: numero a imprimir
    la      t9,  write_digit          # write_digit: imprimo numero segun a0
    jalr    t9


WS_WRITE_M_DIGIT:
    lw      t3,  WS_H_DIGIT($fp)      # El digito del medio lo imprimo solo
    li      t4,  0                    # si el digito mas alto es mayor a 0
    bgt     t3,  t4, WS_WRITE_M_D_OUT # o el digito del medio es mayor a 0
    lw      t2,  WS_M_DIGIT($fp)       
    li      t4,  0                    
    bgt     t2,  t4, WS_WRITE_M_D_OUT
    b       WS_WRITE_L_DIGIT          # sino lo salteo

WS_WRITE_M_D_OUT:
    lw      a0,  WS_A0($fp)           # a0: standard output file descriptor.
    lw      a1,  WS_M_DIGIT($fp)      # a1: numero a imprimir
    la      t9,  write_digit          # write_digit: imprimo numero segun a0
    jalr    t9

WS_WRITE_L_DIGIT:
    lw      a0,  WS_A0($fp)           # a0: standard output file descriptor.
    lw      a1,  WS_L_DIGIT($fp)      # a1: numero a imprimir
    la      t9,  write_digit          # write_digit: imprimo numero segun a0
    jalr    t9

    lw      a0,  WS_A0($fp)           # a0: standard output file descriptor.
    la      a1,  WS_NL                # a1: salto de linea
    li      a2,  1                    # a2: data length.
    la      t9,  sys_write            # encapsulo SYS_write para manejar errores
    jalr    t9
    


    lw      ra,  WS_RA(sp)            # Destruimos el frame.
    move    sp,  $fp
    lw      $fp, WS_FP(sp)
    lw      gp,  WS_GP(sp)
    addu        sp,  sp, WS_STACK_SIZE

    jr      ra
    .end    write_sint                # Retorno

    .rdata
WS_NL:
    .asciiz "\n"
