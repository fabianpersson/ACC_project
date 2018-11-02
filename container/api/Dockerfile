FROM ubuntu
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y python && apt-get install -y python-pip
#RUN apt-get --no-install-recommends install -y octave
RUN pip install --upgrade pip
RUN pip install flask
RUN pip install celery
RUN pip install numpy
RUN pip install sqlalchemy
RUN pip install redis
ADD shared/proj /home/ubuntu/proj
ADD api/app.py /home/ubuntu/
WORKDIR /home/ubuntu/
ENV PW=$pw
EXPOSE 8000
ENTRYPOINT python app.py

