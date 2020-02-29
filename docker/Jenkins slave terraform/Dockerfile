FROM jenkins/jnlp-slave

ARG user=jenkins

USER root
COPY --from=hashicorp/terraform:0.12.20 /bin/terraform /bin/
COPY . .


# etc
#COPY jenkins-agent /usr/local/bin/jenkins-agent
#RUN chmod +x /usr/local/bin/jenkins-agent &&\
#    ln -s /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-slave

RUN addgroup --gid 999 docker && \
    usermod -a -G docker jenkins

USER ${user}



ENTRYPOINT ["jenkins-slave"]