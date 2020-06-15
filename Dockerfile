# === [ STAGE 1 ] ===
FROM library/python:3.7-alpine as base
FROM base as builder

RUN mkdir /install
WORKDIR /install

# Install requirements and libraries.
#   --no-cache allows users to install packages with an index that is updated and used on-the-fly and not cached locally
RUN apk --no-cache --quiet add gcc make g++ bash git openssh \
    postgresql-dev curl build-base libffi-dev python3-dev py-pip \
    jpeg-dev zlib-dev libsass-dev

# Install pillow globally.
ENV LIBRARY_PATH=/lib:/usr/lib

# Add requirements.txt before rest of repo for caching.
COPY requirements.txt /requirements.txt

# Install project dependencies before copying the rest of the codebase.
RUN python -m pip install --install-option="--prefix=/install" -r /requirements.txt

# === [ STAGE 2 ] ===
FROM base
COPY --from=builder /install /usr/local

RUN apk --no-cache --quiet add libpq

# Set project path for use throughout the script.
ENV weatherApp2=/usr/src/app

# Echo the directory to install as a sanity check.
RUN echo "Installing into $weatherApp2..."

# Create project directory on the image.
RUN mkdir -p $weatherApp2

# Create directories the project depends upon.
RUN mkdir -p $weatherApp2/media
RUN mkdir -p $weatherApp2/static/assets

# We need a .env file to start the server.
#COPY deploy/.env.captain $weatherApp/.env
RUN touch $weatherApp2/.env

# Run all commands in this new directory.
WORKDIR $weatherApp2

# Copy this directory to the image.
COPY . $weatherApp2

# Open port 80 to traffic.
EXPOSE 8080 80 443

# Run a startup script in the specified directory.
CMD sh /usr/src/app/deploy/run.sh
