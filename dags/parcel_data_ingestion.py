import os
import logging
from datetime import datetime
from airflow import DAG
from airflow.utils.dates import days_ago
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator
from data_functions import get_parcel_data, upload_to_gcs
from airflow.providers.google.cloud.operators.bigquery import BigQueryCreateExternalTableOperator
import pyarrow.csv as pv
import pyarrow.parquet as pq

PROJECT_ID = os.environ.get("GCP_PROJECT_ID")
BUCKET = os.environ.get("GCP_GCS_BUCKET")
parcel_data_filename = f"parcel_data_{datetime.now().strftime('%Y%m%d-%U')}.parquet"
path_to_local_home = os.environ.get("AIRFLOW_HOME", "/opt/airflow/")
BIGQUERY_DATASET = os.environ.get("BIGQUERY_DATASET", 'wake_cty_data')

default_args = {
    "owner": "airflow",
    "start_date": days_ago(1),
    "depends_on_past": False,
    "retries": 1,
}

with DAG(
    dag_id="parcel_data_ingestion_gcs_dag",
    schedule_interval="@weekly",
    default_args=default_args,
    catchup=False,
    max_active_runs=1,
    tags=['parcels'],
) as dag:

    get_parcel_data_task = PythonOperator(
        task_id="get_parcel_data_task",
        python_callable=get_parcel_data,
        op_kwargs={
            "file_name": f"{path_to_local_home}/{parcel_data_filename}",
        },
    )

    local_to_gcs_task = PythonOperator(
        task_id="local_to_gcs_task",
        python_callable=upload_to_gcs,
        op_kwargs={
            "bucket": BUCKET,
            "object_name": f"raw/{parcel_data_filename}",
            "local_file": f"{path_to_local_home}/{parcel_data_filename}",
        },
    )

    bigquery_external_table_task = BigQueryCreateExternalTableOperator(
        task_id="bigquery_external_table_task",
        table_resource={
            "tableReference": {
                "projectId": PROJECT_ID,
                "datasetId": BIGQUERY_DATASET,
                "tableId": "parcels_external_table",
            },
            "externalDataConfiguration": {
                "sourceFormat": "PARQUET",
                "sourceUris": [f"gs://{BUCKET}/raw/{parcel_data_filename}"],
            },
        },
    )

    cleanup_workspace_task = BashOperator(
        task_id='cleanup_workspace_task',
        bash_command=f"rm {path_to_local_home}/{parcel_data_filename}"
    )

    get_parcel_data_task >> local_to_gcs_task >> bigquery_external_table_task >> cleanup_workspace_task
