FROM jenkinsci/jenkins:latest

 
VOLUME /etc/pki/tls/certs
VOLUME /etc/pki/tls/private
 
# disable setup wizard all together
ENV JAVA_OPTS '-Duser.timezone=Pacific/Auckland -Djenkins.install.runSetupWizard=false'
ENV JENKINS_OPTS ' \
 --httpPort=-1 \
 --httpsPort=443 \
 --httpsCertificate=/etc/pki/tls/certs/cert.crt \
 --httpsPrivateKey=/etc/pki/tls/private/cert.key \
'
 
ADD settings.xml /root/.m2/

USER root

# add keys for docker slaves
ADD id_rsa id_rsa.pub /root/.ssh/
EXPOSE 443
 

VOLUME /var/jenkins_home