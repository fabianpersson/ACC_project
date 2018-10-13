from __future__ import absolute_import, unicode_literals
from .celery import app
from oct2py import octave
import numpy as np

@app.task
def run_octave_file(config=False):
    octave.addpath('/home/ubuntu/files/')
    x = np.array([[1, 2], [3, 4]], dtype=float)
    out, oclass = octave.roundtrip(x)

    return [x, x.dtype, out, oclass, out.dtype]


    
    
