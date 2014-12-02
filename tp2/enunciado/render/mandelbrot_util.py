import os, subprocess
import StringIO
from PIL import Image
import numpy

def pgmdata2pil(pgmdata):
    header = None
    width = None
    height = None
    maxGray = None
    data = []
    pgmlist = pgmdata.splitlines()

    for line in pgmlist:
        stripped = line.strip()

        if stripped[0] == '#': 
            continue
        elif header == None: 
            if stripped != 'P2': return None
            header = stripped
        elif width == None:
            width = int( stripped )
        elif height == None:
            height = int( stripped )
        elif maxGray == None:
            maxGray = int(stripped)
        else:
            for item in stripped.split():
                data.append(int(item.strip()))

    return numpy.reshape(data, ( height, width ) )/float(maxGray)*255

def pgm_to_image( pgmdata ):
    pgm = pgmdata2pil(pgmdata)
    if pgm is not None:
        return Image.fromarray(pgm)

def pgm_to_gif( pgmdata ):

    im = pgm_to_image( pgmdata )
    output = StringIO.StringIO()
    im = im.convert("RGB")
    im.save(output, format='GIF')
    output.seek(0)

    return output

def mandelbrot_pgm( res, center, w, h, m, n ):

    path = os.path.dirname(os.path.realpath(__file__))
    binary = path + "/./tp2"

    call_string = []
    call_string.append( binary )
    if res:
        call_string.append( "-r%s"%( res ) )
    if center:
        call_string.append( "-c%s"%( center ) )
    if w:
        call_string.append( "-w%s"%( w ) )
    if h:
        call_string.append( "-H%s"%( h ) )
    if m:
        call_string.append( "-m%s"%( m ) )
    if n:
        call_string.append( "-n%s"%( n ) )
    call_string.append( "-o-" )

    return subprocess.check_output( call_string )
