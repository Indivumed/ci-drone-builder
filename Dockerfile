FROM docker:18.09.6-dind

RUN apk update
RUN apk add python3-dev libffi-dev openssl-dev gcc libc-dev make py3-pip curl wget bash git \
    && echo "source /etc/profile" >> ~/.bashrc
RUN pip3 install --upgrade pip
# install docker-compose and aws cli
RUN pip3 install docker-compose awscli kubernetes \
  && docker-compose --version \
  && echo "complete -C '/usr/bin/aws_completer' aws" >> ~/.bashrc \
  && aws --version
# install aws-iam-authenticator
RUN curl -o /usr/local/bin/aws-iam-authenticator \
    https://amazon-eks.s3-us-west-2.amazonaws.com/1.13.7/2019-06-11/bin/linux/amd64/aws-iam-authenticator \
   && chmod +x /usr/local/bin/aws-iam-authenticator \
   && aws-iam-authenticator version
# install kubectl
RUN KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt) \
  && curl --tlsv1.3 --ssl-reqd --output /usr/local/bin/kubectl \
     -LO https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl \
  && chmod +x /usr/local/bin/kubectl \
  && kubectl version --client=true \
  && echo "source <(kubectl completion bash) \nalias k=kubectl \ncomplete -F __start_kubectl k" >> ~/.bashrc
# install gomplate
RUN curl -sL -o /usr/local/bin/gomplate \
    https://github.com/hairyhenderson/gomplate/releases/download/v3.5.0/gomplate_linux-amd64 \
   && chmod -c +x /usr/local/bin/gomplate \
   && gomplate --version
