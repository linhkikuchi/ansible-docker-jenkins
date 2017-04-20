FROM centos:latest
 
RUN yum -y install \
  openssh-clients \
  openssh-server \
  redhat-rpm-config \
  rpm-build \
  rsync \
  java-1.8.0-openjdk-headless \
  java-1.8.0-openjdk-devel \
  git \
  subversion 

# Add RPM build support
RUN yum -y install rpm-build wget

# Install latest maven - avoids need for Jenkins to send and unpack jar every time
RUN wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
RUN yum -y install apache-maven

# update sshd settings, create jenkins user, set jenkins user pw, generate ssh keys
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd \
    && mkdir -p /var/run/sshd \
    && useradd -u 1000 -m -s /bin/bash jenkins \
    && echo "jenkins:jenkins" | chpasswd \
    && /usr/bin/ssh-keygen -A \
RUN echo export JAVA_HOME="/`alternatives  --display java | grep best | cut -d "/" -f 2-6`" >> /etc/environment

# Disable password login
RUN sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Set java environment
ENV JAVA_HOME /etc/alternatives/jre

# add public key from jenkins master to slave
ADD authorized_keys /var/jenkins/.ssh/


# For some reason this needs to go in a non-standard location for our jenkins install
ADD settings.xml  /var/jenkins/maven/settings.xml
# Also put in the usual location
ADD settings.xml  /var/jenkins/.m2/settings.xml
RUN chown jenkins:jenkins /var/jenkins/.m2
RUN chown jenkins:jenkins /var/jenkins/maven

# Standard SSH port
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]