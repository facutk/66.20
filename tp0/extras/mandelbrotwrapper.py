#!/usr/bin/env python
import os, pgm2pil, subprocess
from flask import Flask, request, render_template, send_file
from PIL import Image

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
    fname = path + "/generated.pgm"

    #create image
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
    call_string.append( "-o%s"%( fname ) )

    subprocess.call( call_string )

    #convert image
    gif_name = fname + ".gif"
    im = Image.open( fname )
    im = im.convert("RGB")
    im.save( gif_name )

    #send image
    return send_file( gif_name, mimetype='image/gif' )

if __name__ == '__main__':
    app.run(debug = True)
