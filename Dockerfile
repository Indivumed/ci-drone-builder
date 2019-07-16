FROM docker:18.09.6-dind

RUN apk update
RUN apk add python-dev libffi-dev openssl-dev gcc libc-dev make py-pip curl bash gnupg
RUN pip install docker-compose awscli \
  && docker-compose --version \
  && aws --version
# install kubectl
RUN KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt) \
  && curl --tlsv1.3 --ssl-reqd --output /usr/local/bin/kubectl \
     -LO https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl \
  && chmod +x /usr/local/bin/kubectl \
  && kubectl version --client=true
# install gopass
RUN wget https://github.com/gopasspw/gopass/releases/download/v1.8.5/gopass-1.8.5-linux-amd64.tar.gz \
  && tar -xf gopass-1.8.5-linux-amd64.tar.gz \
  && mv gopass-1.8.5-linux-amd64/gopass /usr/local/bin \
  && rm gopass-1.8.5-linux-amd64.tar.gz \
  && rm -rf gopass-1.8.5-linux-amd64 \
  && gopass --version
# install gomplate
RUN curl -sL -o /usr/local/bin/gomplate \
    https://github.com/hairyhenderson/gomplate/releases/download/v3.5.0/gomplate_linux-amd64 \
   && chmod -c +x /usr/local/bin/gomplate \
   && gomplate --version
# install aws-iam-authenticator
RUN curl -o /usr/local/bin/aws-iam-authenticator \
    https://amazon-eks.s3-us-west-2.amazonaws.com/1.13.7/2019-06-11/bin/linux/amd64/aws-iam-authenticator \
   && chmod +x /usr/local/bin/aws-iam-authenticator \
   && aws-iam-authenticator version
