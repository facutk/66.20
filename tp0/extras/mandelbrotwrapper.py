#!/usr/bin/env python
import os, subprocess
import StringIO
from flask import Flask, request, render_template, send_file
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

def imagefrompgmdata( pgmdata ):

    pgm = pgmdata2pil(pgmdata)
    if pgm is not None:

        return Image.fromarray(pgm)

def giffrompgm( pgmdata ):

    im = imagefrompgmdata( pgmdata )
    output = StringIO.StringIO()
    im = im.convert("RGB")
    im.save(output, format='GIF')
    output.seek(0)

    return output


app = Flask(__name__)

@app.route("/")
def index():
    return render_template('index.html')

@app.route("/mandelbrot.gif")
def mandelbrot():

    path = os.path.dirname(os.path.realpath(__file__))
    binary = path + "/./tp0"

    res = request.args.get('res','')
    center = request.args.get('center','')
    w = request.args.get('w','')
    h = request.args.get('h','')

    #call binary
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
    call_string.append( "-o-" )
    pgmdata = subprocess.check_output( call_string )

    #convert to gif
    gifdata = giffrompgm( pgmdata )

    #send image
    return send_file( gifdata, mimetype='image/gif' )

if __name__ == '__main__':
    app.run(debug = True)
