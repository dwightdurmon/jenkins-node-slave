# initially based on https://github.com/bibinwilson/jenkins-docker-slave/blob/master/Dockerfile

FROM ubuntu:18.04

LABEL maintainer="Dwight Durmon <dwight@durmon.com>"

# Make sure the package repository is up to date.
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -qy upgrade

# Install packages
RUN DEBIAN_FRONTEND=noninteractive apt-get install -qy git openssh-server openjdk-8-jdk wget sudo curl gnupg

# Cleanup old packages
RUN apt-get -qy autoremove

# Configure a basic SSH server
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd


# Add user jenkins to the image
RUN useradd -m -d /home/jenkins -s /bin/bash -c "Jenkins" -U jenkins

# Set password for the jenkins user (you may want to alter this).
RUN echo "jenkins:jenkins" | chpasswd
RUN mkdir /home/jenkins/.m2
RUN chown -R jenkins:jenkins /home/jenkins/.m2/

# Install Yarn/NPM/Node

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN DEBIAN_FRONTEND=noninteractive apt-get install -qy yarn nodejs npm


# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
