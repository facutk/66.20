#include <mips/regdef.h>
#include <sys/syscall.h>

    # int calc_brightness( int shades, float cr, float ci )
    #
    # Layout del stack
    # ABA 84 padding
    #     80 a2
    #     76 a1
    #     72 a0   
    # --  -- --   -------
    # SRA 68 ra
    #     64 $fp
    #     60 gp
    #     56 --   padding
    # FRA 52 --   CB_ZR
    #     48 --   CB_ZI
    #     44 --   CB_ZRXZR
    #     40 --   CB_ZIXZI
    #     36 --   CB_ABSZ
    #     32 --   CB_SR
    #     28 --   CB_SI
    #     24 --   CB_ZK_CUBE
    #     20 --   CB_ZK_SQUARE
    #     16 --   CB_ACCUMULATOR
    # LTA 12 --   CB_SHADES
    #     8  --   CB_BRIGHTNESS
    #     4  --   -------
    #     0  --   -------

#define CB_STACK_SIZE   72

#define CB_A2           80
#define CB_A1           76
#define CB_A0           72

#define CB_RA           68
#define CB_FP           64
#define CB_GP           60

#define CB_ZR           52
#define CB_ZI           48
#define CB_ZRXZR        44
#define CB_ZIXZI        40
#define CB_ABSZ         36
#define CB_SR           32
#define CB_SI           28
#define CB_ZK_CUBE      24
#define CB_ZK_SQUARE    20
#define CB_ACCUMULATOR  16

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

    lw      t0,  CB_A0($fp)           # shades = a0
    sw      t0,  CB_SHADES($fp)

    l.s     $f0, CB_A1($fp)           # zr = a1
    s.s     $f0, CB_ZR($fp)

    l.s     $f0, CB_A2($fp)           # zi = a2
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

    l.s     $f2, CB_ZI($fp)           # ABSZ = ABS( ZRXZR + ZIXZI )
    l.s     $f2, CB_ZR($fp)
    add.s   $f0, $f2, $f0
    abs.s   $f0, $f0
    s.s     $f0, CB_ABSZ($fp)


    l.s     $f0, CB_FLOAT_FOUR
    l.s     $f2, CB_ABSZ($fp)
    c.le.s  $f0, $f2
    bc1t    CB_RETURN



    #   FALTA TRADUCIR ESTO!
    #
    #   zk_square = zi * zi;
    #
    #   zk_cube = zr * zr;
    #   zk_cube = zk_cube * zr;
    #
    #   accumulator = zk_square * zr;                                        
    #   accumulator = accumulator * (-3);                                   
    #   accumulator = accumulator + cr;                                   
    #   accumulator = accumulator + zk_cube;                                   
    #
    #   sr = accumulator;
    #
    #   zk_square = zr * zr;
    #
    #   zk_cube = zi * zi;
    #   zk_cube = zk_cube * zi;
    #
    #   accumulator = zk_square * zi;                                        
    #   accumulator = accumulator * 3;                                   
    #   accumulator = accumulator - zk_cube;                                   
    #   accumulator = accumulator + ci;                                   
    #
    #   si = accumulator;
    #
    #   zr = sr;
    #   zi = si;



    lw      t0,  CB_BRIGHTNESS($fp)   # brightness = brightness + 1
    addi    t0,  t0, 1
    sw      t0,  CB_BRIGHTNESS($fp)
    
    b       CB_FOR

CB_RETURN:
    lw      v0,  CB_BRIGHTNESS($fp)

    lw      ra,  CB_RA(sp)            # Destruimos el frame.
    move    sp,  $fp
    lw      $fp, CB_FP(sp)
    lw      gp,  CB_GP(sp)
    addu    sp,  sp, CB_STACK_SIZE

    jr      ra
    .end    calc_brightness           # Retorno

    .rdata
    .align  2
CB_FLOAT_FOUR:
    .word   1082130432

