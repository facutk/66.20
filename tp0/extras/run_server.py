#!/usr/bin/env python
from flask import Flask, request, render_template, send_file
from mandelbrot_util import mandelbrot_pgm, pgm_to_gif

app = Flask(__name__)

@app.route("/")
def index():
    return render_template('index.html')

@app.route("/mandelbrot.gif")
def mandelbrot():

    res     = request.args.get('res','')
    center  = request.args.get('center','')
    w       = request.args.get('w','')
    h       = request.args.get('h','')

    pgm     = mandelbrot_pgm( res, center, w, h )

    gifdata = pgm_to_gif( pgm )

    return send_file( gifdata, mimetype='image/gif' )

if __name__ == '__main__':
    app.run(debug = True)
