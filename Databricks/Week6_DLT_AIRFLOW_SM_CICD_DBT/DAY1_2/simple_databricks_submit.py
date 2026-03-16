from airflow import DAG
from airflow.providers.databricks.operators.databricks import DatabricksSubmitRunOperator
from datetime import datetime


default_args = {
    "owner": "airflow",
}


with DAG(
    dag_id="databricks_python_dbfs_job",
    start_date=datetime(2024, 1, 1),
    schedule=None,        # Airflow 2.7+
    catchup=False,
    default_args=default_args,
) as dag:

    run_dbfs_python_script = DatabricksSubmitRunOperator(
        task_id="run_dbfs_python_script",
        databricks_conn_id="databricks_default",
        json={
            "new_cluster": {
                "spark_version": "13.3.x-scala2.12",
                "node_type_id": "i3.xlarge",
                "num_workers": 1
            },
            "spark_python_task": {
                "python_file": "dbfs:/Volumes/demows/customerdemo_sch/demo_dbfs/demo.py"
            }
        }
    )