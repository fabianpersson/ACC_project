#!flask/bin/python
from __future__ import absolute_import, print_function
from flask import Flask, jsonify
from celery import group, chord
import subprocess
import sys
from proj.tasks import run_octave_file, save, get_task as get_celery_task
from proj.celery import app as celery_app

from celery.result import AsyncResult, GroupResult
from proj.celeryconfig import result_backend
from proj.redisconfig import cache
import time, re, random

app = Flask(__name__)
import time

available_problems = ['I', 'II']
available_methods = ['COS', 'RBF-FD']

@app.route('/api/v1.0/get_stats')
def get_stats():
    timings = []
    timing_prefix = r'[\w\d]{8}\-'
    for key in cache.keys():
        if bool(re.search(timing_prefix,key)): 
            t = cache.get(key)
            timings.append(eval(t))
        
    return jsonify(timings)
    

@app.route('/api/v1.0/<string:method>/<string:problem>')
@app.route('/api/v1.0/<string:method>/<string:problem>/<int:s1>/<int:s2>/<int:s3>/<int:K>/<int:T>/<int:r>/<int:sig>', methods=['GET'])
def index(method, problem='I', s1 = 90, s2 = 100, s3 = 110, K = 100, T = 1.0, r = 0.03 , sig = 0.15):

    parameters = ([s1, s2, s3], K, T, r, sig)
    if problem in available_problems and method in available_methods: #if it's a valid request
        methods = [method]
        problems = []
        base_func = "BSeuCallU{}_{}"
        base_path = "/home/ubuntu/files/BENCHOP/{}"

        request_id = cache.incr('request_id')
        
        callback = save.s(request_id)#.set(priority=0) #prioritze save, so that users don't have to wait for a very long time
        
        tasks = generate_tasks(methods, base_func, base_path, parameters, problem)
        jobs = execute_tasks(tasks)(callback)       

        return jsonify("Your result will be ready within a few minutes. Curl /api/v1.0/task/{}".format(request_id))
    else:
        return jsonify("invalid parameters.")
    
@app.route('/api/v1.0/task/<string:request_id>')    
def get_task(request_id): 
    res = cache.get(request_id)
    return jsonify(res)
   
@app.route('/api/v1.0/benchmark/<int:n_tasks>')     
def benchmark(n_tasks):
    params1 = {"s1": 90, "s2": 100, "s3":110, 'K': 100, "T":1.0, "r": 0.03, "sig":0.15}
    params2 = {"s1": 97, "s2": 98, "s3":99, 'K': 100, "T":0.25, "r": 0.10, "sig":0.1}
    
    for _ in range(0, n_tasks):
        rand_problem = 'I' if random.random() < 0.67 else 'II' ## make problem 1 a bit more likely
        rand_method = random.choice(available_methods)

        if rand_problem == 'I':
            index(rand_method, rand_problem, **params1)
        elif rand_problem == 'II':
            index(rand_method, rand_problem, **params2)
            
            
    expected_time = (0.165*150+10)*n_tasks
    return jsonify("benchmark started. Esimated time is {}".format(expected_time))
    
    
#generate tasks        
def generate_tasks(methods, base_func, base_path, parameters, problem):
    tasks = []
    for method in methods:
        function = base_func.format(problem, method).replace('-', '') 
        path = base_path.format(method)
        
        task_obj = run_octave_file.s(function, path, parameters)
        
        tasks.append(task_obj)
        #tasks.append({"function": function, "path": path})
    return tasks

def execute_tasks(tasks):
    return chord(tasks) #chord


    
    

if __name__ == '__main__':    
    app.run(host='0.0.0.0',debug=True, port=8000)

