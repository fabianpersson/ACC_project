from __future__ import absolute_import, unicode_literals
from .celery import app
from .octave import Octave
from celery.signals import task_prerun, task_postrun
import time
from proj.redisconfig import cache
import socket 
import os

BENCHMARK = True

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

d = {}
timings = []

@task_prerun.connect
def task_prerun_handler(signal, sender, task_id, task, args, kwargs, **extras):
    print 'hey'
    print "signal is {}".format(signal)
    print "sender is {}".format(sender) 
    print "args is {}".format(args)
    print "app is {}".format(app)
    
    print "hostname is {}".format(os.uname()[1])
    d[task_id] = time.time()


@task_postrun.connect
def task_postrun_handler(signal, sender, task_id, task, args, kwargs, retval, state, **extras):
    try:
        end = time.time()
        start = d.pop(task_id)
        cost = end - start
    except KeyError:
        cost = -1
    if BENCHMARK:   
        cache.set(task_id, [task_id, os.uname()[1], start, end, cost, str(task), args[0]]) #hostname/worker, start, end, args/resources group     
    
    print task, cost