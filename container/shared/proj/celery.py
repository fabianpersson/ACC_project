
from __future__ import absolute_import, unicode_literals
from celery import Celery

app = Celery('proj',
             include=['proj.tasks'])

# Optional configuration, see the application user guide.
app.conf.update(
    result_expires=3600,
)


app.config_from_object('proj.celeryconfig')

if __name__ == '__main__':
    app.start()
