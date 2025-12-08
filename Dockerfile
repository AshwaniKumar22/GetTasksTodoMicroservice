# Use the official Python image as the base image
FROM python:3.9

# Set the working directory in the container
WORKDIR /app

# Copy the application files into the container
COPY . .

# Install necessary packages
RUN apt-get update && apt-get install -y curl gnupg unixodbc unixodbc-dev

# Add Microsoft package signing key
RUN curl https://packages.microsoft.com/keys/microsoft.asc \
    | gpg --dearmor \
    | tee /usr/share/keyrings/microsoft.gpg > /dev/null

# Add Microsoft SQL Server repository
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/debian/10/prod buster main" \
    > /etc/apt/sources.list.d/mssql-release.list

# Update repo lists and install msodbcsql17
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql17

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Start the FastAPI application
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
