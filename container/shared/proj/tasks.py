from __future__ import absolute_import, unicode_literals
from .celery import app
from .octave import Octave
from celery.signals import task_prerun, task_postrun
import time 
import redis


@app.task
def run_octave_file(function, cwd, parameters):
    #cwd = '/home/ubuntu/files/BENCHOP/COS'
    
    try:
        octave = Octave()
        res = octave.run(function, parameters, cwd)
        
        
    except Exception as e:
        return e
    return res

@app.task
def save(data):
    cache = redis.Redis(host='redis', port=6379)
    print "We've finished"
    print cache.incr('hits')
    
    
