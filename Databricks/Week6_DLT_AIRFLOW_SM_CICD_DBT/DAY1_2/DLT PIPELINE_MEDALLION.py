from airflow import DAG
from airflow.providers.databricks.operators.databricks import DatabricksSubmitRunOperator
from datetime import datetime

default_args = {
    "owner": "airflow",
    "depends_on_past": False
}

with DAG(
    dag_id="databricks_dlt_pipeline_run",
    start_date=datetime(2024, 1, 1),
    schedule=None,
    catchup=False,
    default_args=default_args,
    tags=["databricks", "dlt", "etl"]
) as dag:

    run_dlt_pipeline = DatabricksSubmitRunOperator(
        task_id="run_dlt_pipeline",
        databricks_conn_id="databricks_default",
        pipeline_task={
            "pipeline_id": "0d224da4-ba92-4898-9ca0-1ffe68789524"
        }
    )

    run_dlt_pipeline