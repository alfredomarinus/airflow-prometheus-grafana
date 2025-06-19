# FROM apache/airflow:3.0.0-python3.11
# COPY requirements.txt .

# RUN pip install --no-cache-dir --trusted-host pypi.org --trusted-host files.pythonhosted.org -r requirements.txt


FROM apache/airflow:3.0.0-python3.11

USER root
# Install extra Python dependencies your DAGs may need
COPY requirements.txt /tmp/requirements.txt
RUN if [ -s /tmp/requirements.txt ]; then \
      pip install --no-cache-dir --trusted-host pypi.org --trusted-host files.pythonhosted.org -r /tmp/requirements.txt ; \
    fi

# Custom entrypoint
COPY airflow-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Airflow runs as airflow UID/GID 50000 by default
USER 50000
