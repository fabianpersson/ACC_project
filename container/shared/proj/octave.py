from subprocess import Popen, PIPE, STDOUT
import numpy as np
# x = np.array([[1, 2], [3, 4]], dtype=float)

class Octave(object):
    def run(self, fn_name, args, filepath):
        
        print("initiaitng session")
        session = self.create_octave_session(filepath)
        print("sesssion {}".format(session))
        stdin = self.func_formatter(fn_name, args)
        print("stdin {}".format(stdin))
        stdout = session.communicate(input=stdin)
        print("stdout {}".format(stdout))
        stdout_parsed = self.parse_output(stdout)
        return stdout_parsed

    # init a octave subprocess 
    @staticmethod
    def create_octave_session(cwd=False):
         return Popen('octave', cwd=cwd, stdout=PIPE, stdin=PIPE, stderr=STDOUT)        
        
    # parse as a function call that we can send to octave
    @staticmethod
    def func_formatter(fn_name, args):
        return '{}{}'.format(fn_name,args)

    @staticmethod
    def parse_output(output):
        return output[0].split('\n')
        


        
