FROM centos:5

ADD CentOS-5.11-EOL.repo /etc/yum.repos.d/CentOS-5.11-EOL.repo

RUN rm -f /etc/yum.repos.d/libselinux.repo /etc/yum.repos.d/CentOS-Base.repo && \
    yum -y clean all && \
    yum -y update

RUN groupadd -r postgres && \
    useradd -r -g postgres postgres && \
    yum -y install postgresql-server sudo && \
    yum -y clean all && \
    rm -f /tmp/*

ADD postgresql.conf /var/lib/pgsql/template/postgresql.conf
ADD pg_hba.conf /var/lib/pgsql/template/pg_hba.conf
ADD start-container /usr/local/bin/start-container

RUN chown postgres:postgres /var/lib/pgsql/template/*.conf && \
    chown postgres:postgres /var/lib/pgsql/* && \   
    sed -i -e "s/Defaults    requiretty.*/ #Defaults    requiretty/g" /etc/sudoers && \
    chmod +x /usr/local/bin/start-container

VOLUME ["/var/lib/pgsql/data"]

EXPOSE 5432

ENV TZ UTC
ENV PG_MAJOR 8.1

ENTRYPOINT [ "start-container" ]