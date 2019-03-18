FROM quay.io/bitnami/apache:2.4.38-ol-7-r45
USER root
RUN groupadd -r apache 
RUN useradd apache -r -g apache -d /var/www -s /sbin/nologin
RUN useradd www-data
RUN install_packages bzip2-libs ca-certificates libffi libselinux ncurses-libs readline sqlite wget xz-libs libxml2 make pcre pcre-devel libxml2-devel mod_security lua-static httpd-devel python36-devel gcc
RUN install_packages oracle-epel-release-el7 oracle-release-el7  python36 python-pip
RUN python3.6 -m venv py36env
RUN source py36env/bin/activate
RUN yum install -y python36-setuptools
RUN easy_install-3.6 pip
RUN pip install --upgrade pip
RUN rm -rf /usr/bin/python
RUN ln -s /usr/bin/python3.6 /usr/bin/python
RUN python -m pip install mod_wsgi


RUN mkdir -p /var/www/engine/documents && chown -R www-data:www-data /var/www/engine/documents
RUN mkdir -p /var/www/engine/wsgi-scripts && chown -R www-data:www-data /var/www/engine/wsgi-scripts
RUN mkdir -p /var/www/engine/certs && chown -R www-data:www-data /var/www/engine/certs
RUN mkdir -p /var/log/engine && chown -R www-data:www-data /var/log/engine
ADD ./conf.d/myapp.wsgi /var/www/engine/wsgi-scripts/myapp.wsgi
#RUN echo "WSGIApplicationGroup %{GLOBAL}" >> /etc/apache2/apache2.conf
#CMD ["apache2ctl", "-D", "FOREGROUND"]

ENV PATH=/opt/bitnami/apache/bin:/opt/bitnami/nami/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ADD ./conf/httpd.conf /bitnami/apache/conf/httpd.conf
ADD ./conf/mod_security.conf /bitnami/apache/conf/mod_security.conf
ADD ./modules /opt/bitnami/apache/modules
COPY ./conf.modules.d /opt/bitnami/apache/conf.modules.d
COPY ./conf.d /opt/bitnami/apache/conf.d
RUN chown -R root /opt/bitnami/apache
RUN chgrp -R root /opt/bitnami/apache
RUN chmod -R o-w /opt/bitnami/apache
RUN chown root:apache /var/log/httpd
RUN chmod o-rwx /var/log/httpd
RUN chmod o-rwx /var/log/httpd
