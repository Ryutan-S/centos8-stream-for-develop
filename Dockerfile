FROM centos:8

# Update to CentOS8 Stream
RUN ["dnf","install","-y","centos-release-stream"]
RUN ["dnf","swap","-y","centos-linux-repos","centos-stream-repos"]
RUN ["dnf","distro-sync","-y"]

# Update the repositories
RUN ["dnf","update"]
RUN ["dnf","upgrade"]

# Change to Japanese environment
RUN ["dnf","install","-y","langpacks-ja"]
ENV LANG="ja_JP.utf8" LANGUAGE="ja_JP:ja" LC_ALL="ja_JP.utf8"
RUN ["ln","-sf","/usr/share/zoneinfo/Asia/Tokyo","/etc/localtime"]

# Add a user for login
RUN ["dnf","install","-y","passwd","sudo","util-linux-user"]
RUN ["useradd","user"]
RUN ["gpasswd","-a","user","wheel"]
RUN ["passwd","-d","user"]

# Install the fish
WORKDIR /etc/yum.repos.d/
RUN ["curl","-fsSLO","https://download.opensuse.org/repositories/shells:fish:/release:/3/CentOS_8/shells:fish:release:3.repo"]
RUN ["dnf","install","-y","fish"]
WORKDIR /root/

# Install the development tools 
RUN ["dnf","install","-y","git","which","unzip","zip","subversion"]

# Install the golang
RUN ["curl","-fsSLO","https://golang.org/dl/go1.15.7.linux-amd64.tar.gz"]
RUN ["tar","-C","/usr/local","-xzf","go1.15.7.linux-amd64.tar.gz"]
RUN ["bash","-c","echo 'export PATH=$PATH:/usr/local/go/bin' >> /etc/profile"]
RUN ["rm","go1.15.7.linux-amd64.tar.gz"]

# Install the alien to install pandoc
RUN ["dnf","install","-y","rpm-build","perl-ExtUtils-MakeMaker","make","perl"]
RUN ["curl","-fsSLO","http://ftp.debian.org/debian/pool/main/a/alien/alien_8.92.tar.gz"]
RUN ["sudo","rpmbuild","-ta","alien_8.92.tar.gz"]
RUN ["rpm","-ivh","/root/rpmbuild/RPMS/noarch/alien-8.92-1.noarch.rpm"]

# Install the pandoc
RUN ["curl","-fsSLO","https://github.com/jgm/pandoc/releases/download/2.13/pandoc-2.13-1-amd64.deb"]
RUN ["alien","--to-rpm","--scripts","pandoc-2.13-1-amd64.deb"]
RUN ["sudo","rpm","-ivh","--force","pandoc-2.13-2.x86_64.rpm"]

# Configuration for login
USER user
WORKDIR /home/user
CMD ["/usr/bin/bash","-l"]
