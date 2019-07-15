FROM docker:18.09.6-dind

RUN apk update
RUN apk add python-dev libffi-dev openssl-dev gcc libc-dev make py-pip curl bash gnupg
RUN pip install docker-compose awscli
RUN KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt) \
  && curl --tlsv1.3 --ssl-reqd --output /usr/bin/kubectl \
     -LO https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl \
  && chmod +x /usr/bin/kubectl
RUN wget https://github.com/gopasspw/gopass/releases/download/v1.8.5/gopass-1.8.5-linux-amd64.tar.gz \
  && tar -xf gopass-1.8.5-linux-amd64.tar.gz \
  && mv gopass-1.8.5-linux-amd64/gopass /usr/bin \
  && rm gopass-1.8.5-linux-amd64.tar.gz \
  && rm -rf gopass-1.8.5-linux-amd64 \
  && gopass --version
RUN curl -sL -o gomplate https://github.com/hairyhenderson/gomplate/releases/download/v3.5.0/gomplate_linux-amd64 \
   && chmod -c +x gomplate \
   && mv gomplate /usr/local/bin \
   && gomplate --version
