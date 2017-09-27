FROM centos:7
MAINTAINER Fady Berty

ENV CA_CERTIFICATES_JAVA_VERSION 20140324
RUN yum makecache \
        && yum update -y \
        && yum install -y \
                       wget \
                       zip \
                       openssh-client \
                       unzip \
                       java-1.8.0-openjdk \
					   jenkins \
        && yum clean all


# SET Jenkins Environment Variables
ENV JENKINS_HOME /var/jenkins_home
ENV JENKINS_SLAVE_AGENT_PORT 50000
ENV JENKINS_VERSION 1.625.2
ENV JENKINS_SHA 395fe6975cf75d93d9fafdafe96d9aab1996233b
ENV JENKINS_UC https://updates.jenkins-ci.org
ENV COPY_REFERENCE_FILE_LOG $JENKINS_HOME/copy_reference_file.log
ENV JAVA_OPTS="-Xmx8192m"
ENV JENKINS_OPTS="--handlerCountStartup=100 --handlerCountMax=300 --logfile=/var/log/jenkins/jenkins.log --webroot=/var/cache/jenkins/war"

# Jenkins is run with user `jenkins`, uid = 1000
RUN useradd -d "$JENKINS_HOME" -u 1000 -m -s /bin/bash jenkins

# Jenkins home directory is a volume
VOLUME /var/jenkins_home

# `/usr/share/jenkins/ref/` contains all reference configuration we want
# to set on a fresh new installation. Use it to bundle additional plugins
# or config file with your custom jenkins Docker image.
RUN mkdir -p /usr/share/jenkins/ref/init.groovy.d

# Install Jenkins
RUN curl -fL http://mirrors.jenkins-ci.org/war-stable/$JENKINS_VERSION/jenkins.war -o /usr/share/jenkins/jenkins.war \
                 && echo "$JENKINS_SHA /usr/share/jenkins/jenkins.war" | sha1sum -c -

# Prep Jenkins Directories
RUN chown -R jenkins "$JENKINS_HOME" /usr/share/jenkins/ref
RUN mkdir /var/log/jenkins
RUN mkdir /var/cache/jenkins
RUN chown -R jenkins:jenkins /var/log/jenkins
RUN chown -R jenkins:jenkins /var/cache/jenkins

# Expose Ports for web and slave agents
EXPOSE 8080
EXPOSE 50000


# Switch to the jenkins user
USER jenkins

# Bash as the entry point to manage zombie processes
ENTRYPOINT ["/bin/bash"]