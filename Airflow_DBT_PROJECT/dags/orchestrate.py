from datetime import datetime

from airflow.sdk import dag, task
from airflow.providers.standard.operators.bash import BashOperator


@dag(
    dag_id="orchestrate",
    start_date=datetime(2024, 1, 1),
    schedule=None,
    catchup=False,
)
def orchestrate():

    @task
    def ingest_cdc():
        return "CDC data ingested"

    @task.bash
    def source_freshness():
        return """
        cd /opt/airflow/walmart_project &&
        dbt source freshness --profiles-dir /opt/airflow/walmart_project
        """

    silver_technical = BashOperator(
        task_id="silver_technical",
        bash_command="cd /opt/airflow/walmart_project && dbt run --select silver_tech --profiles-dir /opt/airflow/walmart_project"
    )

    silver_technical_test = BashOperator(
        task_id="silver_technical_test",
        bash_command="cd /opt/airflow/walmart_project && dbt test --select silver_tech --profiles-dir /opt/airflow/walmart_project"
    )

    silver_business = BashOperator(
        task_id="silver_business",
        bash_command="cd /opt/airflow/walmart_project && dbt run --select silver_busi --profiles-dir /opt/airflow/walmart_project"
    )

    silver_business_test = BashOperator(
        task_id="silver_business_test",
        bash_command="cd /opt/airflow/walmart_project && dbt test --select silver_busi --profiles-dir /opt/airflow/walmart_project"
    )

    gold_ephemeral = BashOperator(
        task_id="gold_ephemeral",
        bash_command="cd /opt/airflow/walmart_project && dbt run --select gold/ehemeral --profiles-dir /opt/airflow/walmart_project"
    )

    gold_dim = BashOperator(
        task_id="gold_dim",
        bash_command="cd /opt/airflow/walmart_project && dbt snapshot --profiles-dir /opt/airflow/walmart_project"
    )

    gold_fact = BashOperator(
        task_id="gold_fact",
        bash_command="cd /opt/airflow/walmart_project && dbt run --select gold/fact --profiles-dir /opt/airflow/walmart_project"
    )

    ingest_task = ingest_cdc()
    freshness_task = source_freshness()

    (
        ingest_task
        >> freshness_task
        >> silver_technical
        >> silver_technical_test
        >> silver_business
        >> silver_business_test
        >> gold_ephemeral
        >> gold_dim
        >> gold_fact
    )


dag = orchestrate()