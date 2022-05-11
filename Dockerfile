FROM python:3.10-slim

WORKDIR /app
RUN apt update
RUN apt install -y git

COPY requirements.txt .
RUN pip install -r requirements.txt