FROM ubuntu:cosmic
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y python && apt-get install -y python-pip 
RUN apt-get install -y octave 
RUN pip install --upgrade pip
RUN pip install celery
RUN pip install sqlalchemy
RUN pip install redis
RUN pip install numpy
ADD shared/proj /home/ubuntu/proj

ARG pw=default
ENV pw=$pw
#ADD celery-queue/files /home/ubuntu/files
ADD benchop.tar.gz/ /home/ubuntu/files/
RUN ls /home/ubuntu/files/
WORKDIR /home/ubuntu/
EXPOSE 5672 
ENTRYPOINT celery -A proj worker --without-heartbeat --loglevel=info --concurrency=2

