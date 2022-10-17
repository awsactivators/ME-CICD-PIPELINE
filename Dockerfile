FROM python:3-alpine
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . /app
EXPOSE 8081
ENTRYPOINT ["python3", "app.py"]