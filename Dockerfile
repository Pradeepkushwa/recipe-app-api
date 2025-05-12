FROM python:3.9-alpine3.13
LABEL maintainer="pradeeppython.com"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8080

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    /py/bin/pip install flake8 && \
    if [ $DEV = "true"]; \
         then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \ 
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user

# FROM python:3.9-alpine3.13
# LABEL maintainer="pradeeppython.com"

# ENV PYTHONUNBUFFERED=1
# ENV PATH="/py/bin:$PATH"

# # Install system dependencies
# RUN apk add --update --no-cache \
#     gcc \
#     python3-dev \
#     musl-dev \
#     libffi-dev \
#     postgresql-dev \
#     build-base \
#     jpeg-dev \
#     zlib-dev

# # Set up virtual environment and install requirements
# RUN python -m venv /py
# COPY ./requirements.txt /tmp/requirements.txt
# RUN /py/bin/pip install --upgrade pip && \
#     /py/bin/pip install -r /tmp/requirements.txt && \
#     /py/bin/pip install gunicorn && \
#     rm -rf /tmp

# # Copy project files
# COPY ./app /app
# WORKDIR /app

# # Expose the port used by Gunicorn
# EXPOSE 8000

# # Use non-root user for security
# RUN adduser --disabled-password --no-create-home django-user
# USER django-user

# # Start the Django application using Gunicorn
# CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app.wsgi:application"]
