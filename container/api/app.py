#!flask/bin/python
from __future__ import absolute_import, print_function
from flask import Flask, jsonify
from celery import group, chord
import subprocess
import sys
from proj.tasks import run_octave_file, save
from proj.celery import app as celery_app
from celery.result import AsyncResult, GroupResult
from proj.celeryconfig import result_backend

app = Flask(__name__)
import time


@app.route('/api/v1.0/<string:method>')
@app.route('/api/v1.0/<string:method>/<string:problem>', methods=['GET'])
def index(method, problem='I'):
    available_problems = ['I', 'II']
    available_methods = ['COS', 'RBF-FD']
    
    if problem in available_problems and method in available_methods: #if it's a valid request
        parameters = ([90, 100, 110], 100, 1.0, 0.03, 0.1)
        methods = [method]
        problems = []
        base_func = "BSeuCallU{}_{}"
        base_path = "/home/ubuntu/files/BENCHOP/{}"

        callback = save.s()
        tasks = generate_tasks(methods, base_func, base_path, parameters, problem)
        #jobs = execute_tasks(tasks)(callback)
        jobs = execute_tasks(tasks)
        result = jobs()
        

        return jsonify("Your result will be ready within a few minutes. Curl /api/v1.0/task/{}".format(jobs.id))
    else:
        return jsonify("invalid parameters.")
    
@app.route('/api/v1.0/task/<string:id_task>')    
def get_task(id_task): 
    #return jsonify(celery_app.backend)
    return jsonify(GroupResult.restore(id_task).get())
   
        
    
    
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
    return group(tasks) #chord
    
    

if __name__ == '__main__':    
    app.run(host='0.0.0.0',debug=True, port=8000)

