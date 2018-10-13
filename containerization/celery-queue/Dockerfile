FROM ubuntu
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y python && apt-get install -y python-pip 
RUN apt-get --no-install-recommends install -y octave 
RUN pip install --upgrade pip
RUN pip install celery
RUN pip install oct2py
RUN pip install numpy
RUN pip install scipy
ADD shared/proj /home/ubuntu/proj
ADD celery-queue/files/ /home/ubuntu/files/
WORKDIR /home/ubuntu/
EXPOSE 5672 
ENTRYPOINT celery -A proj worker  --loglevel=info

