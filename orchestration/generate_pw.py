import os, random, string

length = 100
chars = string.ascii_letters + string.digits
random.seed = (os.urandom(1024))

pw = ''.join(random.choice(chars) for i in range(length))
print(pw)
#os.environ['PW'] = pw
