FROM docker:18.09.6-dind

RUN apk update
RUN apk add python-dev libffi-dev openssl-dev gcc libc-dev make py-pip curl bash
RUN pip install docker-compose awscli
RUN KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt) \
  && curl --tlsv1.3 --ssl-reqd --output /usr/bin/kubectl \
     -LO https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl
RUN chmod +x /usr/bin/kubectl
