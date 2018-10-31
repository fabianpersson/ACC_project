from __future__ import absolute_import, unicode_literals
from .celery import app
from .octave import Octave
from celery.signals import task_prerun, task_postrun
import time 
from proj.redisconfig import cache 


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
def save(results, request_id):
    #cache = redis.Redis(host='redis', port=6379)
    #print data
    
    for res in results:
        cache.set(request_id, res)
    
    print "Task completed. Set result to cache: {}".format(cache.get(request_id))
    
@app.task    
def get_task(request_id):
    
    print "get task called"
    res = cache.get(request_id)
    
    "able to retrieve task"
    return res