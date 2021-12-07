# pull official base image
FROM python:3.9.5-slim
MAINTAINER Ozzy "ozguryarikkas@gmail.com"

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# set work directory and copy all files
WORKDIR /app
COPY . /app

RUN pip install --upgrade pip
# install dependencies
RUN pip install -r requirements.txt
