#include <mips/regdef.h>
#include <sys/syscall.h>

    # typedef struct __sFILE {
    #  0  unsigned char *_p;
    #  4  int    _r;
    #  8  int    _w;
    # 12  short  _flags;
    # 14  short  _file;  // fileno, if Unix descriptor, else -1

#define FILE_FD         14

    # typedef struct param_t {
    #  0  float UL_re;
    #  4  float UL_im;
    #  8  float LR_re;
    # 12  float LR_im;
    # 16  float d_re;
    # 20  float d_im;
    # 24  size_t x_res;
    # 28  size_t y_res;
    # 32  size_t shades;
    # 36  FILE *fp;

#define PARAM_T_FP      36
#define PARAM_T_SHADES  32
#define PARAM_T_Y_RES   28
#define PARAM_T_X_RES   24
#define PARAM_T_D_IM    20
#define PARAM_T_D_RE    16
#define PARAM_T_LR_IM   12
#define PARAM_T_LR_RE    8
#define PARAM_T_UL_IM    4
#define PARAM_T_UL_RE    0

    # void mips32_plot( param_t * parms )
    #
    # Imprimo numero segun a0
    #
    # Layout del stack
    # ABA 92 --   padding
    #     88 a0   *param
    # --  -- --   -------
    # SRA 84 ra
    #     80 $fp
    #     76 gp
    #     72 --   padding
    # FRA 68 --   UL_re
    #     64 --   UL_im
    #     60 --   d_re
    #     56 --   d_im
    #     52 --   cr
    #     48 --   ci
    # LTA 44 --   x_res
    #     40 --   y_res
    #     36 --   shades
    #     32 --   fd
    #     28 --   x
    #     24 --   y
    #     20 --   brightness
    #     16 --   padding
    # ABA 12 a3
    #     8  a2
    #     4  a1
    #     0  a0

#define MP_STACK_SIZE   88

#define MP_PARAM        88

#define MP_RA           84
#define MP_FP           80
#define MP_GP           76

#define MP_UL_RE        68
#define MP_UL_IM        64
#define MP_D_RE         60
#define MP_D_IM         56
#define MP_CR           52
#define MP_CI           48

#define MP_X_RES        44
#define MP_Y_RES        40
#define MP_SHADES       36
#define MP_FILE_D       32

#define MP_X            28
#define MP_Y            24
#define MP_BRIGHTNESS   20

    .text
    .align  2

    .globl  mips32_plot
    .ent    mips32_plot
mips32_plot:

    .frame  $fp, MP_STACK_SIZE, ra
    .set    noreorder
    .cpload t9
    .set    reorder
    subu    sp, sp, MP_STACK_SIZE
    .cprestore MP_GP

    sw      gp,  MP_GP(sp)
    sw      $fp, MP_FP(sp)
    move    $fp, sp
    sw      ra,  MP_RA($fp)

    sw      a0,  MP_PARAM($fp)        # Guardo PARAM en el caller ABA

    lw      t0,  MP_PARAM($fp)        # x_res = param->x_res
    lw      t0,  PARAM_T_X_RES(t0)
    sw      t0,  MP_X_RES($fp)
    
    lw      t0,  MP_PARAM($fp)        # y_res = param->y_res
    lw      t0,  PARAM_T_Y_RES(t0)
    sw      t0,  MP_Y_RES($fp)
    
    lw      t0,  MP_PARAM($fp)        # shades = param->shades
    lw      t0,  PARAM_T_SHADES(t0)
    sw      t0,  MP_SHADES($fp)

    lw      t0,  MP_PARAM($fp)        # fd = param->fp->fd
    lw      t0,  PARAM_T_FP(t0)
    lh      t0,  FILE_FD(t0)
    sw      t0,  MP_FILE_D($fp)

    lw      t0,  MP_PARAM($fp)        # d_re = param->d_re
    l.s     $f0, PARAM_T_D_RE(t0)
    s.s     $f0, MP_D_RE($fp)

    lw      t0,  MP_PARAM($fp)        # d_im = param->d_im
    l.s     $f0, PARAM_T_D_IM(t0)
    s.s     $f0, MP_D_IM($fp)

    lw      t0,  MP_PARAM($fp)        # ul_re = param->ul_re
    l.s     $f0, PARAM_T_UL_RE(t0)
    s.s     $f0, MP_UL_RE($fp)

    lw      t0,  MP_PARAM($fp)        # ul_im = param->ul_im
    l.s     $f0, PARAM_T_UL_IM(t0)
    s.s     $f0, MP_UL_IM($fp)

    li      t0,  0                    # Inicializo brightness = 0
    sw      t0,  MP_BRIGHTNESS($fp)

    li      t0,  0                    # Inicializo Y = 0
    sw      t0,  MP_Y($fp)

    li      t0,  0                    # Inicializo X = 0
    sw      t0,  MP_X($fp)
                                      
    lw      a0,  MP_FILE_D($fp)       # Escribo el HEADER
    lw      a1,  MP_X_RES($fp)        # a0: file descriptor
    lw      a2,  MP_Y_RES($fp)        # a1: x_res
    lw      a3,  MP_SHADES($fp)       # a1: y_res
    la      t9,  header_pgm           # a3: shades
    jalr    t9                        # header_pgm( fd, x_res, y_res, shades )
    
    l.s     $f0, MP_UL_IM($fp)        # ci = UL_im 
    s.s     $f0, MP_CI($fp)

MP_FOR_Y_START:
    lw      t0,  MP_Y($fp)            # t0 = Y
    lw      t1,  MP_Y_RES($fp)        # t1 = Y_RES
    bge     t0,  t1, MP_FOR_Y_END     # si (y >= y_res) ir MP_FOR_Y_END

    li      t0,  0                    # Inicializo X = 0
    sw      t0,  MP_X($fp)

    l.s     $f0, MP_UL_RE($fp)        # cr = UL_re 
    s.s     $f0, MP_CR($fp)

MP_FOR_X_START:
    lw      t0,  MP_X($fp)            # t0: X
    lw      t1,  MP_X_RES($fp)        # t1: X_RES
    bge     t0,  t1, MP_FOR_X_END     # si (x >= x_res) ir MP_FOR_X_END

    lw      a0,  MP_SHADES($fp)       # a0: shades
    lw      a1,  MP_CR($fp)           # a1: cr
    lw      a2,  MP_CI($fp)           # a2: ci
    la      t9,  calc_brightness
    jalr    t9
    sw      v0,  MP_BRIGHTNESS($fp)
    
    lw      a0,  MP_FILE_D($fp)       # a0: file descriptor
    lw      a1,  MP_BRIGHTNESS($fp)   # a1: brightess
    la      t9,  write_sint           # write_sint( fd, brightness )
    jalr    t9

    lw      t0,  MP_X($fp)            # x = x + 1
    addi    t0,  t0, 1
    sw      t0,  MP_X($fp)

    l.s     $f2, MP_CR($fp)           # cr = cr + d_re
    l.s     $f0, MP_D_RE($fp)
    add.s   $f0, $f2, $f0
    s.s     $f0, MP_CR($fp)

    b       MP_FOR_X_START

MP_FOR_X_END:
    lw      t0,  MP_Y($fp)            # y = y + 1
    addi    t0,  t0, 1
    sw      t0,  MP_Y($fp)

    l.s     $f2, MP_CI($fp)           # ci = ci - d_im
    l.s     $f0, MP_D_IM($fp)
    sub.s   $f0, $f2, $f0
    s.s     $f0, MP_CI($fp)

    b       MP_FOR_Y_START

MP_FOR_Y_END:
                                      # flush_result = fflush(parms->fp);

    li      v0,  SYS_sync             # No encuentro implementacion en syscalls
    syscall                           # de fflush.
                                      # Lo mas cercano es SYS_sync.
                                      # no lleva parametros y no devuelve nada
                                      # Consultar esto.
    b       MP_END
                                      # si (flush_result == 0) ir MP_END;
                                      #     fprintf(stderr, "cannot flush output file.\n");
                                      #     exit(1);
MP_END: 
    lw      ra,  MP_RA(sp)            # Destruimos el frame.
    move    sp,  $fp
    lw      $fp, MP_FP(sp)
    lw      gp,  MP_GP(sp)
    addu    sp,  sp, MP_STACK_SIZE

    jr      ra
    .end    mips32_plot                # Retorno
