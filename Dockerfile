FROM python:3.9

WORKDIR /app
COPY . .

# Install required packages
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    apt-transport-https \
    unixodbc \
    unixodbc-dev

# Download and register the Microsoft repository key (NO apt-key)
RUN curl https://packages.microsoft.com/keys/microsoft.asc \
    | gpg --dearmor \
    | tee /usr/share/keyrings/microsoft.gpg > /dev/null

# Add Microsoft SQL Server repository (Debian 11 for Python 3.9)
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] \
    https://packages.microsoft.com/debian/11/prod bullseye main" \
    > /etc/apt/sources.list.d/mssql-release.list

# Install ODBC Driver 18 (NOT driver 17)
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql18

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
