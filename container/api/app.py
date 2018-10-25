#!flask/bin/python
from __future__ import absolute_import
from flask import Flask, jsonify
import subprocess
import sys
from proj.tasks import run_octave_file
app = Flask(__name__)


@app.route('/api/v1.0/', methods=['GET'])
def index():
    
    
    #get user parameters 
    
    function_calls_1a = {
        'BSeuCallUII_COS': '/home/ubuntu/files/BENCHOP/COS'
        
    }
    
    
    
    res = run_octave_file.delay()	
    return jsonify(res.get())

if __name__ == '__main__':    
    app.run(host='0.0.0.0',debug=True, port=8000)

