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

RUN sed -i -e "s/Defaults    requiretty.*/ #Defaults    requiretty/g" /etc/sudoers

VOLUME ["/var/lib/pgsql/data"]
EXPOSE 5432

CMD ["/usr/local/bin/init-postgresql"]
