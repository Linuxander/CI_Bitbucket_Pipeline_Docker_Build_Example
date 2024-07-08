# base image  
FROM python:3.8

# setup environment variable  
ENV DockerHOME=/home/app/webapp

RUN apt update -y
RUN apt install vim tmux -y
RUN apt install iputils-ping -y

# set work directory  
RUN mkdir -p $DockerHOME  

# where your code lives  
WORKDIR $DockerHOME  

# set environment variables  
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1  

# install dependencies  
RUN pip install --upgrade pip  

# copy whole project to your docker home directory. 
COPY docker/ $DockerHOME  

# run this command to install all dependencies  
RUN pip install -r requirements.txt  

# port where you want to expose your web API
EXPOSE 8000  

# Below enter the code that triggers the server you use to serve your API
# IMPORTANT: Ensure it is listed in requirements.txt for this to work
# GUNICORN EXAMPLE: CMD ["gunicorn", "--bind", ":8000", "--workers", "3", "mysite.wsgi:application"]
# FASTAPI EXAMPLE: CMD ["fastapi", "run", "app/main.py", "--port", "8000"]