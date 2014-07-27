FROM centos:centos6
MAINTAINER daitak

RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
RUN sed -i -e "s/enabled *= *1/enabled=0/g" /etc/yum.repos.d/remi.repo

RUN yum -y install openssh-server sudo
RUN yum -y install redis --enablerepo=remi
RUN sed -i -e "s/^bind 127.0.0.1/bind 0.0.0.0/g" /etc/redis.conf 

RUN useradd daiki
RUN mkdir /home/daiki/.ssh
ADD authorized_keys /home/daiki/.ssh/authorized_keys
RUN chown -R daiki:daiki /home/daiki/.ssh
RUN chmod 600 /home/daiki/.ssh/authorized_keys
RUN echo "daiki ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/daiki

EXPOSE 22 6379
ADD init.sh /usr/local/bin/init.sh
RUN chmod u+x /usr/local/bin/init.sh
CMD ["/usr/local/bin/init.sh"]
