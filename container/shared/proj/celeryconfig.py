broker_url = 'amqp://guest:guest@rabbit:5672/'
broker_pool_limit = 1 # Will decrease connection usage
broker_heartbeat = None # We're using TCP keep-alive instead
broker_connection_timeout = 30 # May require a long timeout due to Linux DNS timeouts etc
result_backend = 'rpc://' # AMQP is not recommended as result backend as it creates thousands of queues
event_queue_expires = 60 # Will delete all celeryev. queues without consumers after 1 minute.
worker_prefetch_multiplier = 1 # Disable prefetching, it's causes problems and doesn't help performance
worker_concurrency = 2 # If you tasks are CPU bound, then limit to the number of cores, otherwise increase substainally
