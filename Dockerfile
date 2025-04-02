FROM apache/airflow:2.8.1-python3.10

ENV AIRFLOW_HOME=/opt/airflow \
    INSTANT_CLIENT_ZIP=instantclient-basic-linux.x64-23.7.0.25.01.zip \
    INSTANT_CLIENT_DIR=instantclient_23_7

# Set Oracle client lib path
ENV LD_LIBRARY_PATH="${AIRFLOW_HOME}/${INSTANT_CLIENT_DIR}:${LD_LIBRARY_PATH}" \
    PATH="${AIRFLOW_HOME}/${INSTANT_CLIENT_DIR}:${PATH}"

# Switch to root for installing OS-level dependencies
USER root

RUN apt-get update && apt-get install -y \
    unzip libaio1 curl gcc

# Copy and install Oracle Instant Client
COPY install_oracle_client.sh ${AIRFLOW_HOME}/install_oracle_client.sh
#COPY ${INSTANT_CLIENT_ZIP} ${AIRFLOW_HOME}/${INSTANT_CLIENT_ZIP}
RUN chmod +x ${AIRFLOW_HOME}/install_oracle_client.sh && \
    ${AIRFLOW_HOME}/install_oracle_client.sh && \
    chown -R airflow: ${AIRFLOW_HOME}

# Optional: Set permissions (only needed if Airflow errors on volumes)
RUN mkdir -p ${AIRFLOW_HOME}/dags ${AIRFLOW_HOME}/logs ${AIRFLOW_HOME}/plugins && \
    chown -R airflow: ${AIRFLOW_HOME}

COPY entrypoint.sh ${AIRFLOW_HOME}/entrypoint.sh
RUN chmod +x ${AIRFLOW_HOME}/entrypoint.sh

# Switch back to airflow user
USER airflow

# Install Python dependencies
COPY requirements-local.txt /tmp/requirements-local.txt
RUN pip install --upgrade pip && \
    pip install -r /tmp/requirements-local.txt


# Set Airflow working directory and entrypoint
WORKDIR ${AIRFLOW_HOME}
ENTRYPOINT ["/opt/airflow/entrypoint.sh"]
CMD ["airflow" ,"standalone"]
