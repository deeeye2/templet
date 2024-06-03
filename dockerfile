# Use an official base image from the Docker Hub
FROM ubuntu:20.04

# Maintainer information
LABEL maintainer="you@example.com"

# Set environment variables
ENV APP_HOME /usr/src/app
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Create application directory
RUN mkdir -p $APP_HOME

# Set the working directory
WORKDIR $APP_HOME

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
    python3 \
    python3-pip \
    git \
    curl \
    vim \
    # Clean up to reduce the image size
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy the current directory contents into the container at APP_HOME
COPY . $APP_HOME

# Install application dependencies (example for Python)
RUN pip3 install --no-cache-dir -r requirements.txt

# Add a user and set permissions (optional)
RUN useradd -m myuser && \
    chown -R myuser:myuser $APP_HOME

# Switch to the new user
USER myuser

# Expose the application port
EXPOSE 8080

# Define environment variables for runtime
ENV FLASK_APP app.py
ENV FLASK_ENV development

# Define the command to run the application
CMD ["python3", "app.py"]

# Optional: Define an entrypoint script
# ENTRYPOINT ["sh", "/usr/src/app/entrypoint.sh"]

# Optional: Define health check
# HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl --fail http://localhost:8080 || exit 1
