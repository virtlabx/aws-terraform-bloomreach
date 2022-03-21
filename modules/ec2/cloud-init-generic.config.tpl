#cloud-config
users:
  - name: "${ssh_user}"
    primary_group: "${ssh_user}"
    groups: wheel
    ssh_authorized_keys: "${ssh_authorized_keys}"
    sudo: ALL=(ALL) NOPASSWD:ALL

bootcmd:
  - /sbin/ifconfig eth0 mtu 1400 up

write_files:
 - path: /var/lib/cloud/instance/scripts/fix_system_time.sh
   permissions: '0755'
   content: |
        #!/bin/bash -ex
        echo 'server 169.254.169.123 prefer iburst minpoll 4 maxpoll 4' >> /etc/chrony.conf
        service chronyd restart
        chkconfig chronyd on

%{ if docker_install == true }
 - path: /var/lib/cloud/instance/scripts/docker_install.sh
   permissions: '0755'
   content: |
        #!/bin/bash -ex
        yum update -y
        yum -y install docker
        service docker start
        systemctl enable docker
        usermod -a -G docker ${ssh_user}
%{ endif }

%{ if jenkins_install == true }
 - path: /var/lib/cloud/instance/scripts/jenkins_install.sh
   permissions: '0755'
   content: |
        #!/bin/bash -ex
        yum -y install java-11-openjdk-devel
        wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
        rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
        yum -y install jenkins
        systemctl start jenkins
        systemctl enable jenkins
        yum -y install git
        EOF
%{ endif }

%{ if cloudwatch_install == true }
 - path: /var/lib/cloud/instance/scripts/cloudwatch_install.sh
   permissions: '0755'
   content: |
        #!/bin/bash -ex
        yum install amazon-cloudwatch-agent
%{ endif }

runcmd:
  - [ /var/lib/cloud/instance/scripts/fix_system_time.sh ]

%{ if docker_install == true }
  - [ /var/lib/cloud/instance/scripts/docker_install.sh ]
%{ endif }

%{ if jenkins_install == true }
  - [ /var/lib/cloud/instance/scripts/jenkins_install.sh ]
%{ endif }

%{ if cloudwatch_install == true }
  - [ /var/lib/cloud/instance/scripts/cloudwatch_install.sh ]
%{ endif }