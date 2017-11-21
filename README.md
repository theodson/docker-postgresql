# docker-postgresql-8.1

> PostgreSQL 8.1 for Docker.

```
$ docker build -t postgresql-8.1 .
<snip>

$ docker run -i \
    -p 5555:5432 \
    -e POSTGRESQL_USER=test \
    -e POSTGRESQL_PASS=oe9jaacZLbR9pN \
    -e POSTGRESQL_DB=testdb \
    -e TZ='Australia/NSW'
    postgresql-8.1

2014-07-24 21:51:47 UTC LOG:  database system was shut down at 2014-07-24 21:51:47 UTC
2014-07-24 21:51:47 UTC LOG:  autovacuum launcher started
2014-07-24 21:51:47 UTC LOG:  database system is ready to accept connections

$ psql -h dev.banno.com -p 5555 -U test testdb
Password for user test:
psql (9.3.4, server 8.1.23)
Type "help" for help.

test=#
```

(Example assumes PostgreSQL client is installed on Docker host.)


```
# Stop, remove and run named container in the background
docker container stop pg81_test && \ 
docker container prune -f && \
docker run --name pg81_test -e TZ="Australia/NSW" -d theodson/postgresql:8.1

# Run a command in a running named container
docker exec -it pg81_test psql -U postgres -h localhost -c "select now();"
```


## Environment variables

 - `POSTGRESQL_DB`: A database that is automatically created if it doesn't exist. Default: `docker`
 - `POSTGRESQL_USER`: A user to create that has access to the database specified by `POSTGRESQL_DB`. Default: `docker`
 - `POSTGRESQL_PASS`: The password for `POSTGRESQL_USER`. Default: `docker`
 - `TZ`: The timezone used in the `postgresql.conf` file. Default: `UTC`
