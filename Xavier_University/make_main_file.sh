#!/bin/bash

# rm insertTable.sql if it exists
rm insertTables.sql
touch insertTables.sql

# cat 'xavier_university_{table}.sql' to insertTable.sql
tables=(drop person department degree building student professor studegreelist class enrollment entries)
for table in ${tables[@]}
do
    cat "xavier_university_$table.sql" >> insertTables.sql
done