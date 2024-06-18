# Use the official Python image from the Docker Hub
FROM --platform=linux/amd64 python:3.9

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    gconf-service \
    libasound2 \
    libatk1.0-0 \
    libcairo2 \
    libcups2 \
    libfontconfig1 \
    libgdk-pixbuf2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libpango-1.0-0 \
    libxss1 \
    fonts-liberation \
    libappindicator1 \
    libnss3 \
    lsb-release \
    xdg-utils \
    wget \
    unzip \
    xvfb

# Install Chrome
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && dpkg -i google-chrome-stable_current_amd64.deb || apt-get -fy install

# Install ChromeDriver
RUN CHROME_DRIVER_VERSION=$(wget -qO- https://chromedriver.storage.googleapis.com/LATEST_RELEASE) \
    && wget -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/${CHROME_DRIVER_VERSION}/chromedriver_linux64.zip \
    && unzip /tmp/chromedriver.zip -d /usr/local/bin/ \
    && rm /tmp/chromedriver.zip

# Install Python dependencies
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy local code to the container image
ENV APP_HOME /app
WORKDIR $APP_HOME
COPY . .

# Add a script to run Chrome with xvfb
RUN echo "#!/bin/bash\n\
xvfb-run -a --server-args='-screen 0 1920x1080x24' gunicorn --bind :\$PORT --workers 1 --threads 8 run:app" > /start.sh
RUN chmod +x /start.sh

# Run the web service on container startup
CMD ["/start.sh"]
