# Use a more comprehensive Python base image
FROM python:3.10

# Set environment variables
ENV FLASK_APP=Webapp.py
ENV FLASK_RUN_HOST=0.0.0.0

# Set the working directory in the container
WORKDIR /app

# Install required system libraries
RUN apt-get update && \
    apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
COPY requirements.txt /app/
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

# Create directories for uploads
RUN mkdir -p /app/uploads

# Expose port 5000 for Flask
EXPOSE 5000

# Run the application
CMD ["flask", "run"]
