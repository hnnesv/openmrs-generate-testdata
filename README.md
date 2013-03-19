openmrs_gendata.pl
==================

A script for generating random test data for OpenMRS.

The script generates SQL statements for inserting randomly generated patients with encounters.

Note that this script is very basic and hardcoded for our particular use case.

Usage
-----
The script simply outputs the results to STDOUT:
```
./openmrs_gendata.pl NUM_PATIENTS NUM_ENCOUNTERS_PER_PATIENT | mysql DB -uUSER -p
```

Troubleshooting
---------------
* The perl DateTime module isn't installed by default on Ubuntu:
```
sudo apt-get install libdatetime-perl
```
* For very large datasets, the queries may timeout. To fix this, alter/add the following lines in my.cnf: ```max_allowed_packet = 64M``` (under both [mysqld] and [mysqldump]) and ```wait_timeout = 6000```
