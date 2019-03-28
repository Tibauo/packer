FROM centos
#FROM debian
RUN useradd test
COPY install.tar.gz /opt/
RUN yum update -y \
# apt update -y \
  && cd /opt \
  && tar -xzvf install.tar.gz 
RUN yum install -y wget unzip
RUN cd /opt/ \
  && ./install/install.sh test /home/test
