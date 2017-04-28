FROM centos:5

RUN sed -i 's/enabled=1/enabled=0/' /etc/yum.repos.d/libselinux.repo && sed -i 's/enabled=1/enabled=0/' /etc/yum.repos.d/CentOS-Base.repo
RUN rm -f /etc/yum.repos.d/libselinux.repo /etc/yum.repos.d/CentOS-Base.repo
ADD CentOS-5.11-EOL.repo /etc/yum.repos.d/CentOS-5.11-EOL.repo
RUN yum -y clean all
RUN yum -y update

RUN groupadd -r postgres && useradd -r -g postgres postgres
RUN yum -y install postgresql-server sudo

ADD postgresql.conf /var/lib/pgsql/template/postgresql.conf
ADD pg_hba.conf /var/lib/pgsql/template/pg_hba.conf
RUN chown postgres:postgres /var/lib/pgsql/template/*.conf

ADD init-postgresql /usr/local/bin/init-postgresql
RUN chmod +x /usr/local/bin/init-postgresql

RUN chown postgres:postgres /var/lib/pgsql/*

VOLUME ["/var/lib/pgsql/data"]
EXPOSE 5432

CMD ["/usr/local/bin/init-postgresql"]


# ADD pgdg.list /etc/apt/sources.list.d/pgdg.list
# RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

# RUN apt-get -qq update && LC_ALL=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive apt-get install -y -q postgresql-8.4 libpq-dev

# /etc/ssl/private can't be accessed from within container for some reason
# (@andrewgodwin says it's something AUFS related)
# RUN mkdir /etc/ssl/private-copy; mv /etc/ssl/private/* /etc/ssl/private-copy/; rm -r /etc/ssl/private; mv /etc/ssl/private-copy /etc/ssl/private; chmod -R 0700 /etc/ssl/private; chown -R postgres /etc/ssl/private

## Add over config files
# ADD postgresql.conf /etc/postgresql/8.4/main/postgresql.conf
# ADD pg_hba.conf /etc/postgresql/8.4/main/pg_hba.conf
# RUN chown postgres:postgres /etc/postgresql/8.4/main/*.conf
# ADD init-postgresql /usr/local/bin/init-postgresql
# RUN chmod +x /usr/local/bin/init-postgresql
#
# VOLUME ["/var/lib/postgresql"]
# EXPOSE 5432
#
# CMD ["/usr/local/bin/init-postgresql"]
