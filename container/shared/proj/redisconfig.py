import redis, os

cache = redis.Redis(host='redis', port=6379, password=os.environ['pw'])