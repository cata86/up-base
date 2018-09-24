FROM centos:7
ENV LD_LIBRARY_PATH=/usr/lib/oracle/12.1/client64/lib/:$LD_LIBRARY_PATH
RUN ln -snf /usr/share/zoneinfo/Europe/Rome /etc/localtime && echo "Europe/Rome" > /etc/timezone && \
    INSTALL_PKGS="libaio wget nodejs git gcc-c++ make bzip2" && \
    curl --silent --location https://rpm.nodesource.com/setup_6.x | bash - && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y && \
    wget http://repository.cineca.it/openshift/oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm && \
    wget http://repository.cineca.it/openshift/oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64.rpm && \
    wget http://repository.cineca.it/openshift/oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm && \
    rpm -ivh oracle-instantclient12.1-* && \
    rm -f oracle-instantclient12.1-* && \
    npm install -g oracledb && \
    npm install -g bower grunt && \
    useradd -ms /bin/bash  up
COPY package.json /usr/src/app/package.json
COPY bower.json /usr/src/app/bower.json
COPY .bowerrc /usr/src/app/.bowerrc
RUN chown -R up:up /usr/src/app
USER up
WORKDIR /usr/src/app
RUN npm install && \
    bower install
EXPOSE 3000 3001
