from PIL import Image
import numpy

def pgm2pil(filename):

    try:
        inFile = open(filename)

        header = None
        width = None
        height = None
        maxGray = None
        data = []

        for line in inFile:
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

    except:
        pass

    return None

def imageOpenWrapper(fname):
    pgm = pgm2pil(fname)
    if pgm is not None:
        return Image.fromarray(pgm)
    return origImageOpen(fname)

origImageOpen = Image.open
Image.open = imageOpenWrapper
