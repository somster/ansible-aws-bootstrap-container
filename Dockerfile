# Dockerfile for building Ansible image for Alpine 3, with as few additional software as possible.
#
# @see https://github.com/gliderlabs/docker-alpine/blob/master/docs/usage.md
#
# Version  1.0
#
# pull base image
FROM alpine:3.6
MAINTAINER Wallace Tan <wallace.tan@gmail.com>
# MAINTAINER William Yeh <william.pjyeh@gmail.com>

RUN echo "===> Installing sudo to emulate normal OS behavior ..."  && \
    apk --update add sudo                                          && \
    \
    echo "===> Installing bash supervisor curl ..."  && \
    apk --update add bash bash-doc bash-completion && \
    \
    echo "===> Installing util-linux pciutils usbutils coreutils binutils findutils grep shadow ..."  && \
    apk --update add util-linux coreutils binutils findutils gawk sed grep bc shadow supervisor curl && \
    \
    echo "===> Adding Python runtime..."  && \
    apk --update add python py-pip openssl ca-certificates openssh-client   && \
    apk --update add --virtual build-dependencies \
                python-dev libffi-dev openssl-dev build-base  && \
    pip install --upgrade pip cffi                            && \
    \
    echo "===> Installing supervisor..."  && \
    pip install supervisor==3.2.4         && \
    \
    echo "===> Installing Ansible..."  && \
    pip install ansible==2.4.3.0            && \
    \
    echo "===> Installing boto..."  && \
    pip install boto==2.48.0        && \
    \
    echo "===> Instaling boto3" && \
    pip install boto3==1.6.17   && \
    \
    echo "===> Installing aws-cli..." && \
    pip install awscli==1.14.64       && \
    \
    echo "===> Removing package list..."  && \
    apk del build-dependencies            && \
    rm -rf /var/cache/apk/*               && \
    \
    echo "===> Adding hosts for convenience..."  && \
    mkdir /etc/ansible                           && \
    echo 'localhost' > /etc/ansible/hosts        && \
    \
    echo "===> Enable ash /etc/profile.d/ script color_prompt..."  && \
    mv /etc/profile.d/color_prompt /etc/profile.d/color_prompt.sh

COPY .ash/.profile /root/.profile
RUN source /root/.profile

RUN echo "===> Enable supervisord..."            && \
mkdir /etc/supervisor.d                          && \
echo -e "[program:ashprofile]\ncommand=source /root/.profile\nautorestart=false" > /etc/supervisor.d/source_profile.ini

WORKDIR /tmp/ansible

ONBUILD RUN  echo "===> Updating TLS certificates..."         && \
              apk --update add openssl ca-certificates

ONBUILD  WORKDIR  /tmp
#ONBUILD  COPY  .  /tmp
ONBUILD  RUN  \
              echo "===> Diagnosis: host information..."  && \
              ansible -c local -m setup all

# default command: display Ansible version
CMD [ "ansible", "--version" ]
# dev mode to keep container running as a daemon
#ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
