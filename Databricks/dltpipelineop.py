from airflow import DAG
from airflow.providers.databricks.operators.databricks import DatabricksRunNowOperator
from datetime import datetime

with DAG(
    dag_id="trig_dlt_rajesh",
    start_date=datetime(2024, 1, 1),
    schedule="@daily",
    catchup=False,
    tags=["databricks", "dlt"]
) as dag:

    run_dlt_job = DatabricksRunNowOperator(
        task_id="run_dlt_job_rajesh",
        databricks_conn_id="databricks_default",
        job_id=706774459274197  # <-- your Job ID
    )