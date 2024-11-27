FROM python:3.10-slim

WORKDIR /opt/octodns-webhook

RUN apt-get update && apt-get install -y \
    curl \
    build-essential


# Create a virtual environment and install Python dependencies
RUN python3 -m venv /opt/octodns-webhook/venv
RUN /opt/octodns-webhook/venv/bin/pip install --upgrade pip
RUN /opt/octodns-webhook/venv/bin/pip install octodns flask gunicorn

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Copy the Flask app into the container
COPY webhook.py /opt/octodns-webhook/webhook.py

EXPOSE 8080

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["/opt/octodns-webhook/venv/bin/gunicorn", "--workers", "2", "--bind", "0.0.0.0:8080", "webhook:app"]