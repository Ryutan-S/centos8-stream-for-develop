FROM centos:8

# CentOS8 Stream
RUN ["dnf","install","-y","centos-release-stream"]
RUN ["dnf","swap","-y","centos-linux-repos","centos-stream-repos"]
RUN ["dnf","distro-sync","-y"]

# update repository
RUN ["dnf","update"]
RUN ["dnf","upgrade"]

# Japanese
RUN ["dnf","install","-y","langpacks-ja"]
ENV LANG="ja_JP.utf8" LANGUAGE="ja_JP:ja" LC_ALL="ja_JP.utf8"
RUN ["ln","-sf","/usr/share/zoneinfo/Asia/Tokyo","/etc/localtime"]

# Add user
RUN ["dnf","install","-y","passwd","sudo","util-linux-user"]
RUN ["useradd","user"]
RUN ["gpasswd","-a","user","wheel"]
RUN ["passwd","-d","user"]

# fish install
WORKDIR /etc/yum.repos.d/
RUN ["curl","-fsSLO","https://download.opensuse.org/repositories/shells:fish:/release:/3/CentOS_8/shells:fish:release:3.repo"]
RUN ["dnf","install","-y","fish"]
WORKDIR /root/

# development tools install
RUN ["dnf","install","-y","git","which","unzip","zip"]

# golang install
RUN ["curl","-fsSLO","https://golang.org/dl/go1.15.7.linux-amd64.tar.gz"]
RUN ["tar","-C","/usr/local","-xzf","go1.15.7.linux-amd64.tar.gz"]
RUN ["bash","-c","echo 'export PATH=$PATH:/usr/local/go/bin' >> /etc/profile"]
RUN ["rm","go1.15.7.linux-amd64.tar.gz"]

# login
USER user
WORKDIR /home/user
CMD ["/usr/bin/bash","-l"]
