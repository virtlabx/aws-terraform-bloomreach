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
        yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        export SELINUX_CONTAINER_URL=http://mirror.centos.org/centos/7/extras/x86_64/Packages/
        export LATEST_SELINUX_CONTAINER=`curl $${SELINUX_CONTAINER_URL} -s | grep -oE "container-selinux.*rpm\"" | sed "s/\"//g" | tail -1`
        yum install -y $${SELINUX_CONTAINER_URL}/$${LATEST_SELINUX_CONTAINER}
        export LATEST_FUSE_OVERLAYFS=`curl $${SELINUX_CONTAINER_URL} -s | grep -oE "fuse-overlayfs.*rpm\"" | sed "s/\"//g" | tail -1`
        yum install -y $${SELINUX_CONTAINER_URL}/$${LATEST_FUSE_OVERLAYFS}
        export LATEST_SLIRP4NETNS=`curl $${SELINUX_CONTAINER_URL} -s | grep -oE "slirp4netns.*rpm\"" | sed "s/\"//g" | tail -1`
        yum install -y $${SELINUX_CONTAINER_URL}/$${LATEST_SLIRP4NETNS}
        sed -ie 's/$releasever/7/g' /etc/yum.repos.d/docker-ce.repo
        yum install -y docker-ce
        mkdir -p /etc/systemd/system/docker.service.d/
        systemctl daemon-reload
        systemctl enable docker.service
        systemctl start --no-block docker.service
%{ endif }

%{ if jenkins_install == true }
 - path: /var/lib/cloud/instance/scripts/jenkins_install.sh
   permissions: '0755'
   content: |
        #!/bin/bash -ex
        yum -y update
        yum -y install java-1.8.0
        yum -y remove java-1.7.0-openjdk
        wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
        rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
        yum -y install jenkins
        systemctl start jenkins
        systemctl enable jenkins
        EOF
%{ endif }

%{ if cloudwatch_install == true }
 - path: /var/lib/cloud/instance/scripts/cloudwatch_install.sh
   permissions: '0755'
   content: |
        #!/bin/bash -ex
        mkdir -p /export/binaries/cloudwatch/
        cd /export/binaries/cloudwatch/
        yum install -y https://s3.amazonaws.com/amazoncloudwatch-agent/redhat/amd64/latest/amazon-cloudwatch-agent.rpm
        cat <<EOF > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
            {
               "agent": {
                  "debug": false
               },
              "metrics": {
                "metrics_collected": {
                  "collectd": {},
                  "cpu": {
                    "resources": [
                      "*"
                    ],
                    "measurement": [
                    "time_active",
                    "time_idle",
                    "time_iowait",
                    "time_irq",
                    "time_softirq",
                    "usage_active",
                    "usage_idle",
                    "usage_iowait",
                    "usage_irq",
                    "usage_softirq"
                    ]
                  },
                  "disk": {
                    "measurement": ["used_percent"],
                    "resources": ["*"],
                    "drop_device": true
                  },
                  "mem": {
                    "measurement": [
                    "total",
                    "available",
                    "cached",
                    "free",
                    "used",
                    "used_percent"
                    ]
                  }
                },
                "append_dimensions": {
                    "InstanceId": "\$\{aws:InstanceId\}"
                }
              }
            }
        EOF
        yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
        yum install -y collectd
        sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
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