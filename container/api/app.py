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
import time

app = Flask(__name__)
import time


@app.route('/api/v1.0/<string:method>')
@app.route('/api/v1.0/<string:method>/<string:problem>', methods=['GET'])
def index(method, problem='I'):
    available_problems = ['I', 'II']
    available_methods = ['COS', 'RBF-FD']
    if problem == "I":
        parameters = ([90, 100, 110], 100, 1.0, 0.03, 0.15)
    elif problem == "II":
        parameters = ([97, 98, 99], 100, 0.25, 0.10, 0.01)
    
    if problem in available_problems and method in available_methods: #if it's a valid request
        methods = [method]
        problems = []
        base_func = "BSeuCallU{}_{}"
        base_path = "/home/ubuntu/files/BENCHOP/{}"

        request_id = cache.incr('request_id')
        
        callback = save.s(request_id)
        tasks = generate_tasks(methods, base_func, base_path, parameters, problem)
        jobs = execute_tasks(tasks)(callback)       

        return jsonify("Your result will be ready within a few minutes. Curl /api/v1.0/task/{}".format(request_id))
    else:
        return jsonify("invalid parameters.")
    
@app.route('/api/v1.0/task/<string:id_task>')    
def get_task(id_task): 
    return jsonify(get_celery_task(id_task))
   
        
    
    
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

