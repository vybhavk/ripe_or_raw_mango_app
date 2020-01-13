# Image containing Cloud SDK and GCP deps
FROM gcr.io/cloud-builders/gcloud

# Configure git to pass on username. Works in Cloud Build
# only when using --network=cloudbuild which passes on
# Cloud Build Service Account as creds.
RUN git config --system credential.helper gcloud.sh


FROM python:3.7-slim-stretch

RUN apt-get update && apt-get install -y git python3-dev gcc \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --upgrade -r requirements.txt

COPY app app/

RUN python app/server.py

EXPOSE 5000

CMD ["python", "app/server.py", "serve"]
