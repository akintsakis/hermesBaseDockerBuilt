#FROM ubuntu:14.04
FROM phusion/baseimage:latest
#FROM akintsakis/odysbase
ENV DEBIAN_FRONTEND noninteractive

##java 8
RUN \
    echo "===> add webupd8 repository..."  && \
    echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list  && \
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list  && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886  && \
    apt-get update  && \
    \
    \
    echo "===> install Java"  && \
    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections  && \
    echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections  && \
    DEBIAN_FRONTEND=noninteractive  apt-get install -y --force-yes oracle-java8-installer oracle-java8-set-default  && \
    \
    \
    echo "===> clean up..."  && \
    rm -rf /var/cache/oracle-jdk8-installer  && \
    apt-get clean  && \
    rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
#####

###create user
RUN useradd -ms /bin/bash user
###

###install kamaki
RUN apt-get update -y && apt-get install software-properties-common -y && apt-get install python-software-properties -y
RUN apt-get update -y && add-apt-repository ppa:grnet/synnefo -y && apt-get update -y && apt-get install kamaki -y
### kamaki

###install various
RUN apt-get update -y && apt-get install nano -y
RUN apt-get update -y && apt-get install openssh-server -y
RUN apt-get update -y && apt-get install dstat -y
RUN apt-get update -y && apt-get install screen -y

RUN apt-get update -y && apt-get install openssh-server -y
RUN apt-get update -y && apt-get install dstat -y
RUN apt-get update -y && apt-get install bash-completion -y
RUN apt-get update -y && apt-get install sshpass -y
###

WORKDIR /home/user
### install pfam
RUN apt-get update && apt-get install -yqq hmmer unzip wget
#WORKDIR /opt
RUN wget ftp://ftp.ebi.ac.uk/pub/databases/Pfam/releases/Pfam28.0/Pfam-A.hmm.gz && gunzip *.gz && hmmpress Pfam-A.hmm && rm Pfam-A.hmm
##


COPY /dist/ /home/user/dist/
COPY /ComponentMonitoring/ /home/user/dist/ComponentMonitoring/
COPY /ComponentMonitoring/plist /home/user/plist
COPY /Hermes/ /home/user/Hermes/


#COPY .kamakirc /root/.kamakirc
#COPY /files/ /home/files/
#COPY simple_client.jar /home/user/client.jar

###setup ssh
#RUN rm -f /etc/service/sshd/down

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
#RUN /etc/my_init.d/00_regen_ssh_host_keys.sh
#ADD id_thk.pub /tmp/id_thk.pub
#ADD id_thk /root/.ssh/identity

#RUN cat /tmp/id_thk.pub >> /root/.ssh/authorized_keys && rm -f /tmp/id_thk.pub
#RUN echo 'Host *' >> /root/.ssh/config
#RUN echo 'StrictHostKeyChecking no' >> /root/.ssh/config
#RUN echo 'IdentityFile /root/.ssh/identity' >> /root/.ssh/config

###


