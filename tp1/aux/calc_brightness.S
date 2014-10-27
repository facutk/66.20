#include <mips/regdef.h>
#include <sys/syscall.h>

    # int calc_brightness( int shades, float cr, float ci )
    #
    # Layout del stack
    # ABA 92 padding
    #     88 a2
    #     84 a1
    #     80 a0   
    # --  -- --   -------
    # SRA 76 ra
    #     72 $fp
    #     68 gp
    #     64 --   padding
    # FRA 60 --   CB_ZR
    #     56 --   CB_ZI
    #     52 --   CB_ZRXZR
    #     48 --   CB_ZIXZI
    #     44 --   CB_ABSZ
    #     40 --   CB_SR
    #     36 --   CB_SI
    #     32 --   CB_ZK_CUBE
    #     28 --   CB_ZK_SQUARE
    #     24 --   CB_ACCUMULATOR
    #     20 --   CB_CR
    #     16 --   CB_CI
    # LTA 12 --   CB_SHADES
    #     8  --   CB_BRIGHTNESS
    #     4  --   -------
    #     0  --   -------

#define CB_STACK_SIZE   80

#define CB_A2           88
#define CB_A1           84
#define CB_A0           80

#define CB_RA           76
#define CB_FP           72
#define CB_GP           68

#define CB_ZR           60
#define CB_ZI           56
#define CB_ZRXZR        52
#define CB_ZIXZI        48
#define CB_ABSZ         44
#define CB_SR           40
#define CB_SI           36
#define CB_ZK_CUBE      32
#define CB_ZK_SQUARE    28
#define CB_ACCUMULATOR  24
#define CB_CR           20
#define CB_CI           16

#define CB_SHADES       12
#define CB_BRIGHTNESS   8

    .text
    .align  2

    .globl  calc_brightness
    .ent    calc_brightness
calc_brightness:

    .frame  $fp, CB_STACK_SIZE, ra
    .set    noreorder
    .cpload t9
    .set    reorder
    subu    sp, sp, CB_STACK_SIZE
    .cprestore CB_GP

    sw      gp,  CB_GP(sp)
    sw      $fp, CB_FP(sp)
    move    $fp, sp
    sw      ra,  CB_RA($fp)

    sw      a0,  CB_A0($fp)           # Guardo en caller ABA
    sw      a1,  CB_A1($fp)
    sw      a2,  CB_A2($fp)

    l.s     $f0, CB_A1($fp)           # cr = a1
    s.s     $f0, CB_CR($fp)

    l.s     $f0, CB_A2($fp)           # ci = a2
    s.s     $f0, CB_CI($fp)

    lw      t0,  CB_A0($fp)           # shades = a0
    sw      t0,  CB_SHADES($fp)

    l.s     $f0, CB_CR($fp)           # zr = cr
    s.s     $f0, CB_ZR($fp)

    l.s     $f0, CB_CI($fp)           # zi = ci
    s.s     $f0, CB_ZI($fp)

    li      t0,  0                    # brightness = 0
    sw      t0,  CB_BRIGHTNESS($fp)

CB_FOR:
    lw      t0,  CB_BRIGHTNESS($fp)   # t0 = brightness
    lw      t1,  CB_SHADES($fp)       # t1 = shades
    bge     t0,  t1, CB_RETURN        # si (brightness >= shades) ir CB_RETURN


    l.s     $f2, CB_ZR($fp)           # ZRXZR = ZR*ZR
    l.s     $f0, CB_ZR($fp)
    mul.s   $f0, $f2, $f0
    s.s     $f0, CB_ZRXZR($fp)

    l.s     $f2, CB_ZI($fp)           # ZIXZI = ZI*ZI
    l.s     $f0, CB_ZI($fp)
    mul.s   $f0, $f2, $f0
    s.s     $f0, CB_ZIXZI($fp)

    l.s     $f2, CB_ZIXZI($fp)        # ABSZ = ZRXZR + ZIXZI
    l.s     $f0, CB_ZRXZR($fp)
    add.s   $f0, $f2, $f0
    s.s     $f0, CB_ABSZ($fp)

    l.s     $f0, CB_FLOAT_FOUR        # si ( 4 < absz ) ir fin
    l.s	    $f2, CB_ABSZ($fp)
    c.lt.s  $f0, $f2
    bc1t    CB_RETURN

    l.s     $f2, CB_ZI($fp)           # ZK_SQUARE = ZI * ZI
    l.s     $f0, CB_ZI($fp)
    mul.s   $f0, $f2, $f0
    s.s     $f0, CB_ZK_SQUARE($fp)

    l.s     $f2, CB_ZR($fp)           # ZK_CUBE = ZR * ZR * ZR
    l.s     $f0, CB_ZR($fp)
    mul.s   $f0, $f2, $f0
    mul.s   $f0, $f2, $f0
    s.s     $f0, CB_ZK_CUBE($fp)


    l.s     $f2, CB_ZK_SQUARE($fp)
    l.s     $f0, CB_ZR($fp)           # accumulator = zk_square * zr
    mul.s   $f0, $f2, $f0             #

    l.s	    $f2, CB_FLOAT_MINUS_THREE # accumulator = accumulator * (-3)
    mul.s   $f0, $f2, $f0             #

    l.s     $f2, CB_CR($fp)           # accumulator = accumulator + cr
    add.s   $f0, $f2, $f0             #

    l.s     $f2, CB_ZK_CUBE($fp)      # accumulator = accumulator + zk_cube
    add.s   $f0, $f2, $f0             #

    s.s     $f0, CB_SR($fp)           # sr = accumulator;


    l.s     $f2, CB_ZR($fp)           # ZK_SQUARE = ZR * ZR
    l.s     $f0, CB_ZR($fp)
    mul.s   $f0, $f2, $f0
    s.s     $f0, CB_ZK_SQUARE($fp)

    l.s     $f2, CB_ZI($fp)           # ZK_CUBE = ZI * ZI * ZI
    l.s     $f0, CB_ZI($fp)
    mul.s   $f0, $f2, $f0
    mul.s   $f0, $f2, $f0
    s.s     $f0, CB_ZK_CUBE($fp)

    l.s     $f2, CB_ZK_SQUARE($fp)
    l.s     $f0, CB_ZI($fp)           # ACCUMULATOR = ZK_SQUARE * ZI
    mul.s   $f0, $f2, $f0             #

    l.s     $f2, CB_FLOAT_THREE       # ACCUMULATOR = ACCUMULATOR * 3
    mul.s   $f0, $f2, $f0             #

    l.s     $f2, CB_ZK_CUBE($fp)      # ACCUMULATOR = ACCUMULATOR - ZK_CUBE
    sub.s   $f0, $f0, $f2             #

    l.s     $f2, CB_CI($fp)           # ACCUMULATOR = ACCUMULATOR + CI
    add.s   $f0, $f2, $f0             #

    s.s     $f0, CB_SI($fp)           # SI = ACCUMULATOR

    l.s     $f0, CB_SR($fp)           # ZR = SR
    s.s     $f0, CB_ZR($fp)

    l.s     $f0, CB_SI($fp)           # ZI = SI
    s.s     $f0, CB_ZI($fp)

    lw      t0,  CB_BRIGHTNESS($fp)   # brightness = brightness + 1
    addi    t0,  t0, 1
    sw      t0,  CB_BRIGHTNESS($fp)
    
    b       CB_FOR

CB_RETURN:
    lw      v0,  CB_BRIGHTNESS($fp)

    lw	    ra,  CB_RA(sp)            # Destruimos el frame.
    move    sp,  $fp
    lw	    $fp, CB_FP(sp)
    lw	    gp,  CB_GP(sp)
    addu	sp,  sp, CB_STACK_SIZE

    jr      ra
    .end    calc_brightness           # Retorno

    .rdata
    .align  2
CB_FLOAT_FOUR:
    .word   1082130432

    .align  2
CB_FLOAT_THREE:
    .word   1077936128

    .align  2
CB_FLOAT_MINUS_THREE:
     .word  -1069547520
