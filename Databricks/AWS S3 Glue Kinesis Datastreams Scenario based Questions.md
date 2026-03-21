AWS S3 Glue Kinesis Datastreams / fire hose data streams real time scenarios:

\------------------------------------------------------------------------------





AWS S3:



**1. Data Not Visible After Upload:**



**Scenario:**



**You uploaded files to S3, but your job (Glue/Databricks) cannot see them.**



*Check:* correct path (bucket/folder) , file format , IAM permissions

*Root Cause:* Wrong path or delayed processing logic

*Fix:* Validate path: 	aws s3 ls s3://bucket/path/

&#x09;		Ensure correct prefix usage



**2. Access Denied Error**



**Scenario: Your job fails with “Access Denied”.**



Check: IAM role / bucket policy / ACLs

Fix: Add permissions:

&#x09;	s3:GetObject

&#x09;	s3:PutObject

&#x09;	s3:ListBucket



3\. Too Many Small Files Problem



*Scenario:* Thousands of small files causing slow performance.



*Impact:* Slow Spark jobs / High cost

*Fix:* Use: file compaction (merge files)



*In Databricks:*



OPTIMIZE table; Increase batch size during ingestion



4\. Duplicate Data in S3



**Scenario:** Same file processed multiple times.



**Debug:** Check file names / metadata



**Root Cause:** Reprocessing or no tracking

**Fix:** Maintain: processed file log

**Use:** idempotent pipelines / Deduplicate downstream



5\. Partitioning Strategy Issue



**Scenario:** Query performance is very slow.



**Debug:** Check: folder structure

**Root Cause:** No partitioning or wrong partition key

**Fix:** Use partitioning like: s3://bucket/data/year=2025/month=03/day=21/Filter on partition columns



**6. Data Skew Due to Partitioning**



**Scenario: One partition is huge, others small.**



**Root Cause:** Poor partition key (e.g., country with uneven distribution)

**Fix:** Use:  better partition key / composite partitioning



**7. Eventual Consistency Confusion**



**Scenario: File uploaded but not immediately visible to processing job.**



Explanation:

S3 is strongly consistent now, but older systems may behave differently



Fix: 		Ensure proper triggers / sensors

&#x09;	Add slight delay if needed



**8. File Format Issue**



**Scenario: Databricks/Glue cannot read files.**



**Debug:** Check: format (CSV, JSON, Parquet)

**Fix:** Convert to: Parquet (columnar, efficient)



**10. Schema Evolution Problem**



**Scenario: New columns added to files, job fails.**



**Debug:** Compare schema



**Fix:** 	Enable schema evolution:

&#x09;	Spark: mergeSchema

&#x09;		Handle missing columns





**11.Data Corruption / Bad Files**



**Scenario: Some files are corrupted.**



**Check:** Identify bad files



**Fix:**



**Use:**



quarantine folder

Move bad data separately



**12. Cross-Account Access**



**Scenario: Another AWS account needs access to your S3 data.**



**Check** bucket policy

**Fix:**

Add cross-account IAM role

Update bucket policy



**13. Triggering Pipeline on File Arrival**



**Scenario: You want to run pipeline when file arrives.**



**Fix:**



Use: S3 event → Lambda → Airflow trigger Or Airflow S3KeySensor



**14. Versioning \& Recovery**



**Scenario: File accidentally deleted.**



**Fix:**



Enable: S3 versioning

&#x09;Restore previous version



**15. Large File Upload Failure**



**Scenario: Upload fails for large files.**



**Fix:**



**Use:** multipart upload



**16. Data Lake Governance**



**Scenario: Multiple teams accessing S3 data.**



**Fix:**



**Use:**

proper folder structure

IAM policies



**Integrate with:**

Glue Data Catalog / Unity Catalog



**17. Reading Partitioned Data Issue**



**Scenario: Query returns no data even though files exist.**



**Check : Check partitions**



**Fix:**



MSCK REPAIR TABLE table;



**18. High Latency in Data Processing**



**Scenario: Pipeline delay due to S3 reads.**



**Fix:**



Use:



Parquet format

partition pruning

Cache data if needed



**19.Production Scenario:**



**Scenario: Your pipeline fails at night due to missing files.**





**Check:**  file arrival timing

**Add:**    sensor / validation step

**Handle:** missing file scenario gracefully



====================================================================================

&#x09;		GLUE JOBS REAL TIME CHALLENGES





1\. Incremental Load Not Working (Job Bookmark Issue)



Scenario: Glue job either: reprocesses old data OR skips new data



Debug:



**Check:**



Job bookmark enabled?

Bookmark keys (timestamp / file path)



**Root Cause:**

Wrong bookmark column

Bookmark corruption



**Fix:**

Use proper key (e.g., last\_updated)



Reset bookmark:



\--job-bookmark-option job-bookmark-disable

Re-enable after fix



**2. Schema Drift in Source Data**



**Scenario: New columns added → job fails or ignores them**



**Compare:**



incoming file schema

Glue table schema



**Fix:**



Enable schema update in crawler



Handle dynamically:



resolveChoice(specs=\[('col', 'cast:string')])



3\. Slow Performance / Long Running Jobs 🚨





Scenario: Glue job takes hours





**Check:**



shuffle size

stages in Spark UI



**Root Cause:**



Large joins

No partitioning

Small files



**Fix:**



Use:



partition pruning

pushdown predicates

Increase DPUs

Optimize joins (broadcast small tables)



**4. Memory / Executor Failure**



**Scenario: Job fails with memory error**



Check CloudWatch logs



**Root Cause:**



Data skew

Large dataset in memory



**Fix:**



Increase:

worker type (G.1X → G.2X)



Avoid:

.collect()



Use:

repartition



5\. Data Quality Issues (Nulls, Duplicates)



Scenario: Bad data entering downstream systems



Debug:

df.filter(col("id").isNull()).count()



Fix:



Clean data:



df.dropDuplicates()

df.na.fill("NA")



6\. Partition Not Detected



Scenario: Data exists but query returns empty



🔍 Debug:

SHOW PARTITIONS table;



Fix: MSCK REPAIR TABLE table;



7\. Glue Crawler Not Updating Schema



Scenario: New columns not reflected



🔍 Debug:

Check crawler config



Fix:



Enable:

“Update all new and existing partitions”

Rerun crawler



8\. Access Denied (IAM Issue)



Scenario: Glue cannot read/write S3



🔍 Debug:

Check IAM role attached to job



Fix:



Add:

s3:GetObject

s3:PutObject

s3:ListBucket





9\. Duplicate Data in Target Table



Scenario: Same records multiple times



🔍 Debug:

Check:

source ingestion

incremental logic



Fix:



Use:

primary key dedup



In Spark:



df.dropDuplicates(\["id"])



10\. Job Timeout / Long Execution



Scenario: Job fails after timeout



🔍 Debug:

Check job timeout config



Fix:



Increase timeout

Optimize transformations





11\. File Format Issues



Scenario: Glue fails to read files



🔍 Debug:

Check format (CSV, JSON, Parquet)



Fix: Convert to Parquet



Use correct reader:



spark.read.parquet()



12\. Small Files Problem 🚨



Scenario: Thousands of small files slow job



🔍 Impact:

More overhead

Slow execution



Fix:



Compact files

Use larger batch ingestion



13\. Cross-Account Data Access



Scenario: Glue job cannot access S3 in another account



🔍 Debug:

Check bucket policy



Fix:

Add cross-account role

Update trust policy



14\. Dependency / Library Issues



Scenario: Custom library not working



🔍 Debug:

Check job parameters



Fix:



Upload .whl to S3



Use:



\--extra-py-files



15\. Data Type Conversion Errors



Scenario: String → int conversion fails



🔍 Debug:

Identify bad records



Fix:



df.withColumn("col", col("col").cast("int"))

Handle invalid values



16\. Concurrent Job Limit



Scenario: Multiple jobs fail to start



🔍 Debug:

Check AWS limits



Fix:



Increase concurrency limit

Queue jobs



17\. Writing to S3 Fails



Scenario: Output not written



🔍 Debug:

Check path \& permissions



Fix:

df.write.mode("overwrite").parquet("s3://path/")



18\. Debugging Production Failure



Scenario: Glue job fails in production at midnight



**Answer:**



Check CloudWatch logs

Identify error (schema, permission, data issue)

Validate input data

Fix issue

Rerun job

Add alerting



**19. Integration with Databricks Issue**



**Scenario: Data written by Glue not readable in Databricks**



**🔍 Debug:**

Check format \& schema



**Fix:**



Use:

Parquet / Delta

Ensure consistent schema



20\.  **Production Challenge**



**Scenario: Pipeline works in dev but fails in prod**



**🔍 Debug:**



Compare:

data volume

schema differences



**Fix:**



Make pipeline:

scalable

schema-flexible



====================================================



##### &#x09;	**Amazon Kinesis Data Streams (KDS)**



**1. Hot Shard Problem** 



**Scenario: One shard is overloaded, causing throttling and delays.**



Debug:



**Check CloudWatch:**



IncomingBytes

WriteProvisionedThroughputExceeded



**Root Cause:**



Poor partition key (e.g., same user\_id)



**Fix:**



Use:



high-cardinality partition key

add random suffix (salting)



Reshard: Split shard



**2. Throughput Exceeded Exception**



**Error: ProvisionedThroughputExceededException**



**🔍 Debug:**



Check:



writes > 1 MB/sec per shard

reads > 2 MB/sec per shard



**Fix:**



Increase shard count



Batch records:

PutRecords instead of PutRecord



**3. Consumer Lag (Delayed Processing)**



**Scenario: Data is delayed in processing.**



Debug:  



Monitor: GetRecords.IteratorAgeMilliseconds



Root Cause: Slow consumer (Spark / Lambda) 



**Fix:**



Increase: consumer parallelism



Use:



Enhanced Fan-Out

Optimize processing logic



**4. Data Loss Concern**



**Scenario: Some records missing in downstream system.**



**🔍 Debug:**



Compare: producer vs consumer counts



Root Cause: Consumer didn’t read within retention period



Fix: Increase retention (up to 7 days) / Add retry logic in producer



**5. Duplicate Data** 



**Scenario:  Same record processed multiple times.**



Reason:



Kinesis = at-least-once delivery



**Fix:**



Implement:

idempotent logic



Use:



unique keys

Deduplicate in downstream (Delta Lake MERGE)





**6. Ordering Issues**





**Scenario:  Events processed out of order.**



Key Concept: Ordering is guaranteed only within a shard



**Fix:** 



Use:



same partition key for related events



**7. Scaling Issue (Traffic Spike)**



**Scenario: Traffic increases suddenly (10x)**



**🔍 Debug:** Check shard utilization



**Fix:**



Reshard: split shards



Enable auto scaling (if configured)



**8. Checkpointing Issue (Spark Streaming)**



**Scenario: Job restarts and reprocesses data.**



**Debug:** Check checkpoint path



**Fix:**



Use:



reliable checkpoint (S3)

Don’t change checkpoint path



**9. Small Records vs Large Records Problem**



&#x20;**Scenario: Too many small records → inefficiency**



**Fix:**



Batch records before sending

Use aggregation on producer side



**10. Security / Access Issue**



**Scenario: Producer/consumer cannot access stream**



**🔍 Debug:**



Check IAM role



**Fix:**



Add:



kinesis:PutRecord

kinesis:GetRecords



**11. Latency vs Cost Trade-off**



**Scenario: Need real-time but cost is high**



**Fix:**



Tune: shard count

Use:  Firehose if near-real-time is acceptable







**12. Integration with Databricks (Streaming Issue)**



**Scenario: Streaming from Kinesis to Databricks is slow**



**🔍 Debug:**



**Check:**

micro-batch interval

cluster size





**Fix:**



Tune: 



trigger interval

Scale cluster

Optimize transformations





**13. Poison Pill Records (Bad Data)**



&#x20;**Scenario: One bad record crashes consumer**



**🔍 Debug:**

Identify problematic record





**Fix:**



Add:



try-catch logic

Send bad data to:

DLQ (Dead Letter Queue)





**14. Retention Period Issue**



**Scenario: Consumer down → data lost**



Root Cause:

Default retention = 24 hours



**Fix:** 



Increase retention (up to 7 days)



**15. Multi-Consumer Problem**



**Scenario: Multiple applications reading same stream**



**🔍 Issue:**

**Shared throughput**





**Fix:**



Use:

Enhanced Fan-Out (dedicated throughput per consumer)





**16. Monitoring \& Debugging** 



**Scenario: Pipeline issues but no visibility**



**Debug:**



**Use CloudWatch metrics:**



IncomingRecords

IteratorAge

Throttling





**Fix:**



Set alarms

Enable logging





**17. Backpressure Problem**



**Scenario: Consumer cannot keep up with producer**



🔍 Debug:

Increasing lag





**Fix:**



Scale consumers

Optimize processing



**18. Data Format Issues**



**Scenario: Consumer fails to parse data**



🔍 Debug:

Check raw payload





**Fix:**



Standardize format (JSON/Avro)

Validate before sending





**19. Real Production Scenario** 





&#x20;**Scenario:  Streaming pipeline stopped at midnight**



Answer:



Check CloudWatch metrics

Identify lag / throttling

Check consumer logs

Fix issue (scaling / code)

Restart consumer

Replay data if needed





**20. End-to-End Real Scenario** 





**Scenario: High traffic + duplicates + delay**



&#x20;**Answer:**





“In our project, we faced hot shard issues due to poor partition key design, which caused throttling. We resolved it by redesigning the partition key with higher cardinality and splitting shards.



We also handled duplicate records using idempotent processing in downstream Delta tables.



Additionally, we reduced consumer lag by enabling enhanced fan-out and scaling our Spark streaming jobs.”



============================================================================================



**1. Data Delivery Delay** 



**Scenario: Data is reaching S3 with delay (5–10 minutes)**



🔍 Debug:



Check:



Buffer size (MB)

Buffer interval (seconds)





**Root Cause:**



Large buffer configuration



**Fix:**



Reduce:

Buffer size (e.g., 128MB → 5MB)

Buffer interval (300 sec → 60 sec)





**Trade-off:**



Lower latency = higher cost



**2. Data Not Delivered to Destination**



**Scenario: Firehose is running but no data in S3**



**🔍 Debug:**



Check:



CloudWatch logs

Delivery stream status





**Root Cause:**

IAM permission issue

Wrong S3 path





**Fix:**



Add:

s3:PutObject

s3:ListBucket

Verify bucket name/prefix





**3. Lambda Transformation Failure** 



**Scenario: Firehose transformation fails**



**🔍 Debug:**



Check:



Lambda logs in CloudWatch



Root Cause:



Invalid JSON

Code error





**Fix:**



Add error handling:



try:

&#x20;   # transform

except:

&#x20;   return failed\_record

Enable backup S3 for failed records





**4. Data Format Conversion Issue**



**Scenario: JSON → Parquet conversion fails**



🔍 Debug:

Check schema definition





**Root Cause:**



Nested JSON / schema mismatch





**Fix:**



Flatten JSON

Correct schema mapping



**5. Duplicate Records**

&#x20;

**Scenario: Duplicate data in S3**



🔍 Reason:

Firehose retries on failure





**Fix:**



Implement dedup downstream:

use unique keys

Delta MERGE





**6. Small Files Problem** 





**Scenario: Too many small files in S3**



**Root Cause: Small buffer size**



**Fix:**



Increase buffer size

Compact files later (Databricks OPTIMIZE)





&#x20;**7. High Latency vs Cost Trade-off**



&#x20;**Scenario: Need faster data but cost increases**



**Fix:**



Tune:



buffer interval

buffer size









**8. Schema Evolution Issue**



&#x20;**Scenario: New fields added → downstream failure**



**🔍 Debug:**

Check incoming JSON





**Fix:**



Enable schema evolution in downstream

Preprocess in Lambda





**9. Firehose Not Scaling**





**Scenario: High data volume causes delays**



🔍 Debug:

Check throughput metrics





&#x20;Fix:



Firehose auto-scales, but:

ensure destination can handle load

Optimize downstream system





**10. S3 Partitioning Issue**



**Scenario: Poor query performance**



**Root Cause:**

No partitioning





&#x20;**Fix:**



Use dynamic partitioning:



s3://bucket/year=2026/month=03/day=21/



**11. Redshift Load Failure**



**Scenario: Firehose fails to load into Redshift**



**🔍 Debug:**



Check:



intermediate S3 bucket

COPY command logs





**Fix:**



Ensure:



correct IAM role

proper table schema





**12. Data Loss Concern**



**Scenario: Records missing**



🔍 Debug:

Check backup S3 bucket





**Fix:**



Enable: S3 backup for all records



**13. Compression Issue**



**Scenario: High storage cost**



**Fix:** 



Enable: GZIP / Snappy compression



**14. Security Issue**



**Scenario: Sensitive data exposure**



**Fix:**



Enable: 



SSE-S3 or SSE-KMS encryption

Use IAM roles





**15. Integration with Databricks**



**Scenario: Data from Firehose not properly read in Databricks**



**🔍 Debug:**



Check:



file format

schema





&#x20;**Fix:**



Use:



Parquet format

Apply schema correctly





**16. Real-Time vs Near Real-Time Confusion**



**Scenario: Need real-time processing but using Firehose**



**Explanation:**



Firehose = near real-time (buffer-based)





&#x20;**Fix:**



**Use:**



Kinesis Data Streams for real-time

Firehose for batch/near real-time





**17. Monitoring \& Debugging**



**Scenario: No visibility into failures**



**🔍 Debug:**



Use CloudWatch:



DeliveryToS3.Success

DeliveryToS3.Failure



**Fix:**



Set alerts

Enable logging





**18. Event Ordering Issue**



&#x20;**Scenario:  Events out of order**



**Explanation:**



Firehose does not guarantee strict ordering



**Fix:**



Handle ordering downstream





&#x20;**19. Large Record Issue**



**Scenario:  Record too large**



**🔍 Root Cause:**

Firehose limit (\~1MB per record)





**Fix:**



Split records before sending





20\. Real Production Scenario 



&#x20;Scenario: Pipeline delayed + duplicates + schema issues



&#x20;**Answer:**





“In our project, we faced delays due to large buffer intervals in Firehose, which we optimized to reduce latency.



We also handled duplicate records using idempotent processing in downstream Delta tables.



For schema changes, we implemented preprocessing using Lambda before loading into S3.”









