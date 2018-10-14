from __future__ import absolute_import, unicode_literals
from .celery import app
from .octave import Octave

@app.task
def run_octave_file(config=False):
    path = '/home/ubuntu/files'
    octave = Octave(cwd=path)
    res = octave.run('roundtrip',2)
    
    return res
    


    
    
