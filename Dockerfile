# Use the official Python image as the base image
FROM python:3.9

# Set the working directory in the container
WORKDIR /app

# Copy the application files into the container
COPY . .

# Install necessary packages
RUN apt-get update && apt-get install -y curl gnupg2 apt-transport-https unixodbc unixodbc-dev

# Add Microsoft package signing key
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

# Add Microsoft SQL Server repository (Debian 11 for Python:3.9 base image)
RUN curl https://packages.microsoft.com/config/debian/11/prod.list \
    > /etc/apt/sources.list.d/mssql-release.list

# Install ODBC Driver 18
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql18

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Start the FastAPI application
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
