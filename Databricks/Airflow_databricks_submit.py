from airflow import DAG
from airflow.providers.databricks.operators.databricks import DatabricksPipelineRunOperator
from datetime import datetime

PIPELINE_ID = "d5cce67e-a4bf-4af8-9e1e-cb932f0f8b2d"

with DAG(
    dag_id="trigger_dlt_pipeline",
    start_date=datetime(2024, 1, 1),
    schedule_interval="@daily",
    catchup=False
) as dag:

    run_dlt = DatabricksPipelineRunOperator(
        task_id="run_dlt_pipeline",
        databricks_conn_id="databricks_default",
        pipeline_id=PIPELINE_ID
    )