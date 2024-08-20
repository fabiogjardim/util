create  table covid(
dt string,
location_key string,
new_confirmed string,
new_deceased string,
new_recovered string,
new_tested string,
cumulative_confirmed string,
cumulative_deceased string,
cumulative_recovered string,
cumulative_tested string
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\;'
STORED AS TEXTFILE
location 's3a://raw/covid'
tblproperties ("skip.header.line.count"="1");


select count(*) from covid;

