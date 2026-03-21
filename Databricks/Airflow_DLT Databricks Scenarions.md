&#x09;		Airflow:

&#x20;                      ==========





1\. Task Failure Handling



Scenario: One task in your DAG fails. What happens next?



Airflow marks DAG as failed



Solution:





retries

retry\_delay

on\_failure\_callback

Use trigger rules like all\_done if needed





2\. Partial Pipeline Failure



Scenario: Your DAG has 5 tasks. Task 3 fails. Tasks 4 \& 5 depend on it.



Tasks 4 \& 5 won’t run



Solution:



1. Fix and rerun from failed task
2. Use task clearing
3. Use depends\_on\_past=False carefully



3\. Backfill / Historical Data Load:



Scenario: You need to process last 30 days of data.





Use:



start\_date

catchup=True



Run:



airflow dags backfill -s 2024-01-01 -e 2024-01-30 dag\_name



Ensure pipeline is idempotent



4\. Handling Late Arriving Data



Scenario: Your data arrives late in S3. DAG runs before data arrives.



Use:



1.S3KeySensor

2.custom sensor

3.delay DAG using TimeDeltaSensor

4.Event-based triggers



5\. Triggering Databricks Job from Airflow



Scenario:



You need to run a Databricks job from Airflow.



Solution:



Use: DatabricksSubmitRunOperator and Pass: cluster config and notebook path / job id



6\. Dynamic DAG / Dynamic Tasks



Scenario:You have 100 files in S3 and need to process each.



Use: Dynamic task mapping



Example:



@task

def process(file):

&#x20;   ...



process.expand(file=file\_list)



7\. Handling Large DAGs (Scalability)



Scenario: Your DAG has 200+ tasks and is slow.



solution: 	Task grouping

&#x09;	SubDAGs (less preferred now)

&#x09;	Parallelism settings

&#x09;		Tune:

&#x09;			parallelism

&#x09;			dag\_concurrency



8\. Retry Strategy



Scenario: Your API call fails intermittently.



Solution:



&#x09;	retries=3,

&#x09;	retry\_delay=timedelta(minutes=5)



&#x09;		Add:

&#x09;		exponential backoff

&#x09;		Avoid infinite retriesmax\_active\_runs



9\. Idempotency



Scenario: Your DAG runs twice accidentally. How do you avoid duplicate data?



Solution:



Design pipeline as idempotent



Apply:



&#x09;overwrite mode

&#x09;merge (upsert)

&#x09;unique keys



10\. Inter-task Communication



Scenario: You need to pass data between tasks.



solution:



Apply XCom



But:

&#x09;Avoid large data

&#x09;Store large data in S3 instead





11\. Scheduling Issue



Scenario: Your DAG is not triggering on time.



Solution:



Check:



&#x09;start\_date

&#x09;schedule\_interval

&#x09;Timezone

&#x09;Scheduler status





12\. DAG Runs Overlapping



Scenario: Your DAG runs every hour but takes 2 hours.



Solution:



Set:



max\_active\_runs=1 Or optimize job Or allow parallel runs carefully





13\. Data Quality Check



Scenario: You want to validate data before loading to target.



Solution:



Add validation task:



&#x09;row count check

&#x09;null check

&#x09;Fail DAG if validation fails



14\. Secrets Management



Scenario: You are storing passwords in DAG code which is not correct





Solution:



Utilise :



&#x09;Airflow Connections

&#x09;AWS Secrets Manager

&#x09;Environment variables



15\. Monitoring \& Alerts



Scenario: How do you know if DAG fails?



Solution:



Email alerts:  email\_on\_failure=True



Integrate: Slack / PagerDuty



Logs: Airflow UI / CloudWatch



16\. File-Based Trigger



Scenario: Run DAG only when file arrives in S3.



Solution:



Use: S3KeySensor Or Event-driven (Lambda → Airflow trigger)



17\. DAG Dependency



Scenario: One DAG depends on another DAG.



Solution:



Use: ExternalTaskSensor Or Trigger DAG using API



18\. Performance Optimization



Scenario: Airflow scheduler is slow.



Solution:



Tune:



&#x09;Scheduler settings

&#x09;Reduce DAG complexity

&#x09;Avoid heavy logic inside DAG



19\. Version Control



Scenario: How do you manage DAG changes?



Solution: Store DAGs in Git / Use CI/CD pipeline / Deploy to Airflow



20\. In production



Scenario: Pipeline fails at 2 AM. What do you do?



Solution:



* Check logs
* Identify failure point
* Fix issue
* Rerun failed task
* Notify stakeholders
* Add alerting for future

=================================================



Delta Live Tables (DLT) with Medallion architecture (Bronze → Silver → Gold)



Bronze Layer Challenges (Raw Ingestion):

\---------------------------------------------



***1.Challenge: Schema Drift / Changing Schema***



(New columns coming in source data)



Solution:



Enable: option("mergeSchema", "true")



In DLT: @dlt.table(schema="..." )



Use:	cloudFiles.inferColumnTypes

&#x09;Schema evolution mode



***2.Challenge: Corrupted / Bad Files (CSV/JSON malformed)***



Solution:



Use: option("badRecordsPath", "/bad\_records/")



Enable rescue column: option("rescuedDataColumn", "\_rescued\_data")



***3.Challenge: Duplicate Data (Reprocessing) (Auto Loader re-ingests same files)***



Solution:



Use: CloudFiles with checkpointing



Maintain: \_metadata.file\_name / Deduplicate later in Silver



4.Challenge: Late Arriving Data



Solution:



Use: watermarking (if streaming) Or handle in Silver layer using merge logic



**Silver Layer Challenges (Cleansed Data)**

**-------------------------------------------**



***1.Challenge: Data Quality Issues***



(nulls, invalid values, duplicates)



Solution (DLT Expectations):



@dlt.expect("valid\_id", "id IS NOT NULL")

@dlt.expect\_or\_drop("valid\_age", "age > 0")



Options:



expect → log only

expect\_or\_drop → drop bad records

expect\_or\_fail → fail pipeline



***2.Challenge: Deduplication***



Solution:



Use:



ROW\_NUMBER() OVER (PARTITION BY id ORDER BY timestamp DESC)

Keep latest record



***3.Challenge: Incremental Processing***



**Solution:**



Use:



DLT incremental tables



Or:



APPLY CHANGES INTO



**4.Challenge: Handling CDC (Change Data Capture)**



**Solution:**



APPLY CHANGES INTO silver\_table

FROM bronze\_table

KEYS (id)

SEQUENCE BY timestamp



***Gold Layer Challenges (Business Layer):***



***Challenge: Aggregation Performance***



*Solution:*



*Use: Partitioning*



*Z-ORDER: OPTIMIZE table ZORDER BY (customer\_id)*



***Scenario: Business metrics are incorrect.***



***Validate:*** <i>group by logic</i>



***joins:***



***Root Cause:*** <i>Duplicate rows in Silver / Wrong aggregation logic</i>



***Fix:*** <i>Fix upstream duplication / Recalculate aggregates</i>



***Challenge: Slow Queries***



*Solution:*



*Use:*



*Delta caching*

*Materialized views*

*Proper indexing strategy*



***Challenge: Data Consistency***



Solution:



Use: Delta Lake ACID transactions



Ensure: No partial writes



***Challenge:* Incremental Load Not Working**





Pipeline reprocessing full data instead of incremental.



**Check:** checkpoint / incremental logic



**Fix:**



**Use:** Auto Loader/DLT incremental tables

&#x20;    Validate watermark / sequence column







***Pipeline-Level Challenges (DLT Specific)***

***-----------------------------------------------***



***1.Challenge: Pipeline Failure***



***Pipeline Suddenly Fails After Working Fine -- DLT pipeline was running fine, now it fails without code change.***





Solution:



Check:



**DLT event logs :** SELECT \* FROM event\_log ORDER BY timestamp DESC



**Look for:**



ERROR

schema mismatch

data type issues



**Root Cause:**

Upstream schema change (new column / datatype change)



**Fix:**



Enable schema evolution:



option("mergeSchema", "true")

Or explicitly define schema





*Fix issue and restart pipeline*



**Use:**



Retry logic



**Challenge:** Debugging Issues



**Solution:**



**Use:** DLT UI (Data lineage graph)



**Event logs:** SELECT \* FROM event\_log



***Challenge: Long Running Pipelines***



**Solution:**



**Optimize:**



Cluster size

Auto-scaling



**Use:**



Continuous vs triggered mode correctly





***Challenge:* Data Not Appearing in Silver Table**



**Scenario:** Bronze has data, but Silver is empty.



**Debug:**



**Check:** Transformation logic / Filters



**Validate:** SELECT COUNT(\*) FROM bronze\_table



**Root Cause:** Incorrect filter condition (e.g., WHERE status = 'active')/ Join mismatch



**Fix:** Test logic independently / Remove filters temporarily / Validate joins



***Challenge:* Duplicate Records in Silver**



**Scenario:** Duplicate data appearing in downstream tables.



**Debug:** Check Bronze ingestion:  SELECT file\_name, COUNT(\*) FROM bronze GROUP BY file\_name



**Root Cause:** Reprocessing same files / No dedup logic



**Fix:**  Add deduplication:



ROW\_NUMBER() OVER (PARTITION BY id ORDER BY timestamp DESC)

Use checkpointing in Auto Loader



**Late Arriving Data Not Processed**



**Scenario:** New records not reflected in Silver/Gold.



**Check:**



timestamps / watermark logic



**Root Cause:** Late data outside watermark window



**Fix:** Increase watermark threshold / Use merge logic instead of strict windowing



**Pipeline Stuck / Not Progressing**



Scenario: Pipeline is running but no data processed.



Check: checkpoint location / new files availability



Root Cause: No new data / Checkpoint corruption



Fix: Reset checkpoint (carefully) / Validate source path



**Permission Issues**



Scenario: DLT cannot read/write tables.



Check: Unity Catalog permissions / storage access



Fix:



Grant: GRANT SELECT, INSERT ON TABLE table\_name TO user;



**Performance Challenges:**

**--------------------------**



***Challenge: Data Skew***



Solution:



Use:



Salting technique



Repartition:



df.repartition(10, "column")



**Challenge: Small File Problem**

**--------------------------------**



**Solution:**



**Use:**



OPTIMIZE table



Enable Auto Optimize: spark.databricks.delta.optimizeWrite = true



**Cost Challenges**



***Challenge: High Compute Cost***



**Solution:**



**Use:**



Auto-scaling clusters

Job clusters instead of all-purpose



**Optimize:**



Pipeline frequency



**Governance \& Security**



***Challenge: Data Access Control***



**Solution:**



Use Unity Catalog



**Apply:**



Table-level permissions

Column-level security





======================================================



***Major frequently occurring issues***



1\. Duplicate data issue



Answer: Dedup in Silver using window functions



2\. Schema changes



Answer: Enable schema evolution in Bronze



3\. Pipeline failure



Answer: Use event logs + restart + fix root cause



4\. Performance issue



&#x20;Answer: Optimize joins, partitioning, Z-order



5\. Incremental load



&#x20;Answer: Use APPLY CHANGES INTO

