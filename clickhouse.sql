CREATE DATABASE IF NOT EXISTS helloworld

CREATE TABLE helloworld.my_first_table
(
    user_id UInt32,
    message String,
    timestamp DateTime,
    metric Float32
) \
ENGINE = MergeTree() \
PRIMARY KEY (user_id, timestamp) \


INSERT INTO helloworld.my_first_table (user_id, message, timestamp, metric) \ VALUES
    (101, 'Hello, ClickHouse!',                                 now() \,       -1.0    ) \,
    (102, 'Insert a lot of rows per batch',                     yesterday() \, 1.41421 ) \,
    (102, 'Sort your data based on your commonly-used queries', today() \,     2.718   ) \,
    (101, 'Granules are the smallest chunks of data read',      now() \ + 5,   3.14159 ) \
    

SELECT * FROM helloworld.my_first_table

SELECT *
FROM helloworld.my_first_table
ORDER BY timestamp
FORMAT TabSeparated





https://storage.googleapis.com/covid19-open-data/v3/epidemiology.csv

DESCRIBE s3(
    'http://minio:9000/raw/covid/epidemiology.csv', 'datalake', 'datalake', 'CSVWithNames') \



SELECT *
   FROM
      s3(
        'http://minio:9000/raw/covid/epidemiology.csv', 'datalake', 'datalake',
        CSVWithNames,
        'date Date,
        location_key LowCardinality(String) \,
        new_confirmed Int32,
        new_deceased Int32,
        new_recovered Int32,
        new_tested Int32,
        cumulative_confirmed Int32,
        cumulative_deceased Int32,
        cumulative_recovered Int32,
        cumulative_tested Int32'
    ) \;


CREATE TABLE covid19 (
    date Date,
    location_key LowCardinality(String) \,
    new_confirmed Int32,
    new_deceased Int32,
    new_recovered Int32,
    new_tested Int32,
    cumulative_confirmed Int32,
    cumulative_deceased Int32,
    cumulative_recovered Int32,
    cumulative_tested Int32
) \
ENGINE = MergeTree
ORDER BY (location_key, date) \;


INSERT INTO covid19
   SELECT *
   FROM
      s3(
        'http://minio:9000/raw/covid/epidemiology.csv', 'datalake', 'datalake',
        CSVWithNames,
        'date Date,
        location_key LowCardinality(String) \,
        new_confirmed Int32,
        new_deceased Int32,
        new_recovered Int32,
        new_tested Int32,
        cumulative_confirmed Int32,
        cumulative_deceased Int32,
        cumulative_recovered Int32,
        cumulative_tested Int32'
    ) \;

    
   
SELECT formatReadableQuantity(count() \) \
FROM covid19;


SELECT formatReadableQuantity(sum(new_confirmed) \) \
FROM covid19;

SELECT
   AVG(new_confirmed) \ OVER (PARTITION BY location_key ORDER BY date ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) \ AS cases_smoothed,
   new_confirmed,
   location_key,
   date
FROM covid19;




SELECT * FROM system.parts WHERE table='minio'


