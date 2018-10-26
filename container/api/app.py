#!flask/bin/python
from __future__ import absolute_import
from flask import Flask, jsonify
from celery import group
import subprocess
import sys
from proj.tasks import run_octave_file
app = Flask(__name__)


@app.route('/api/v1.0/<string:method>', methods=['GET'])
def index(method):
    parameters = ([90, 100, 110], 100, 1.0, 0.03, 0.1)
    methods = [method]
    problems = []
    base_func = "BSeuCallUII_{}"
    base_path = "/home/ubuntu/files/BENCHOP/{}"
    
    tasks = generate_task_list(methods, base_func, base_path)
    jobs = group(run_octave_file.delay(task['function'], task['path'], parameters) for task in tasks) 
    result = jobs()
    
    return jsonify(result.get())

def generate_task_list(methods, base_func, base_path):
    tasks = []
    for method in methods:
        function = base_func.format(method).replace('-', '') 
        path = base_path.format(method)
        tasks.append({"function": function, "path": path})
    return tasks
    

if __name__ == '__main__':    
    app.run(host='0.0.0.0',debug=True, port=8000)

