FROM jenkins/jnlp-slave

ARG user=jenkins

USER root
COPY --from=hashicorp/terraform:0.12.20 /bin/terraform /bin/
COPY . .


# etc
#COPY jenkins-agent /usr/local/bin/jenkins-agent
#RUN chmod +x /usr/local/bin/jenkins-agent &&\
#    ln -s /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-slave

FROM gerritforge/gerrit-ci-slave-bazel:debian-stretch
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/debian \
      $(lsb_release -cs) \
      stable" && \
    apt-get update && \
    apt-get install -y docker-ce git-
    

RUN usermod -a -G docker jenkins

USER ${user}

ENTRYPOINT ["jenkins-slave"]