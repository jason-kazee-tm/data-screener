# Dockerfile for Python Flask Backend

# Use the official Python image from the Docker Hub
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Copy the requirements.txt file first to install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Set environment variables
ENV FLASK_APP=app.py

# Expose the port that Flask runs on
EXPOSE 5000

# Command to run the application
CMD [ "flask", "run", "--host=0.0.0.0" ]