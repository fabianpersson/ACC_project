from subprocess import Popen, PIPE, STDOUT
import numpy as np
import re 
import time
# x = np.array([[1, 2], [3, 4]], dtype=float)

class Octave(object):
    def run(self, fn_name, args, filepath):
        octave_command = self._prepare_function_call(fn_name, args)
        session = self._create_octave_session(filepath) 
        
        start = time.time()
        stdout = self._run_octave_command(session, octave_command)
        execution_time = time.time()-start
  
        print("stdout {}".format(stdout))
        answer = self._parse_output(stdout)
       
  
        return {fn_name: answer, "time": execution_time}

    @staticmethod
    def _prepare_function_call(self, filepath, fn_name, args):
        session = self.create_octave_session(filepath)
        return session, stdin
    
   
    @staticmethod
    def _run_octave_command(session, octave_command):
        return session.communicate(input=octave_command)
    
    # init a octave subprocess 
    @staticmethod
    def _create_octave_session(cwd=False):
         return Popen('octave', cwd=cwd, stdout=PIPE, stdin=PIPE, stderr=STDOUT)        
        
    # parse as a function call that we can send to octave
    @staticmethod
    def _prepare_function_call(fn_name, args):
        print(tuple(args))
    
        return '{}{}'.format(fn_name,tuple(args))

    @staticmethod
    def _parse_output(stdout):
        result = stdout[0]
        
        #search for answer an a newline, indicating an answer was found
        answer_start_idx = re.search(r'ans(.*)(\n+)', result).start(2) 
        answer = result[answer_start_idx:].strip('\n').split()
        return answer


        
