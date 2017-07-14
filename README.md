# ansible-docker-jenkins
Playbook to build jenkins master and slaves on docker TLS

## Build Jenkins Master and Slave on Docker

Before running the playbook
- Create hosts file with Server name inside
echo "dds_name" >> hosts
 
To rebuild server first run copybackupfile.yml and then docker.yml
```
ansible-playbook copybackupfile.yml -i hosts -u root --extra-vars "server_name=ape"
ansible-playbook docker.yml -i hosts -u root --extra-vars "dds_name=<server_name> dds_host=<ip>"
ansible-playbook jenkins-docker.yml -i hosts -u root --extra-vars "dds_name=<server_name> server_name=<short_name>"
```
Otherwise just run
``` 
ansible-playbook docker.yml -i hosts -u root --extra-vars "dds_name=<server_name> dds_host=<ip>"
ansible-playbook jenkins-docker.yml -i hosts -u root --extra-vars "dds_name=<server_name> server_name=<short_name>"
```
server_name=[short_name]
dds_host is the IP

For example
```
ansible-playbook docker.yml -i hosts -u root --extra-vars "dds_name=tool-jenkins.net dds_host=192.168.1.1"
```

Jenkins master need to call slave with extra hosts option (Jenkins config)
## VOLUME
- /var/jenkins_home: for all jenkins config and plugins
- /usr/share/jenkins/jenkins.war: to store latest jenkins in case jenkins is updated on UI

To start docker manually on server:
```
docker run --name jenkins-master -v /etc/pki/tls/certs:/etc/pki/tls/certs -v /etc/pki/tls/private:/etc/pki/tls/private -v /jenkins-backup:/var/jenkins_home -v /jenkins-war/jenkins.war:/usr/share/jenkins/jenkins.war --publish 443:443 -p 25:25 -d jenkins-master
```

