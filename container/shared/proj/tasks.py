from __future__ import absolute_import, unicode_literals
from .celery import app
from .octave import Octave

@app.task
def run_octave_file(config=False):
    cwd = '/home/ubuntu/files/BENCHOP/COS'
    parameters = [90, 100, 110], 100, 1.0, 0.03, 0.15
    
    
    
    try:
        octave = Octave()
        res = octave.run('BSeuCallUII_COS', parameters, cwd)
        
        
    except Exception as e:
        return e
    return res
    


    
    
