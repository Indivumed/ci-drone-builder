FROM docker:20.10.18-dind
ENV TZ=UTC
RUN apk update \
  && apk add python3-dev py3-pip rust libffi-dev openssl-dev gcc libc-dev make \
             curl wget bash git sqlite jq cargo \
  && echo "source /etc/profile" >> ~/.bashrc
RUN pip3 install --upgrade pip
# install docker-compose and AWS tools
# FIXME: awsebcli is having pretty outdated dependencies to docker-compose, requests and awscli
RUN pip3 install --ignore-installed \
                 docker-compose==1.29.2 awscli==1.25.77 \
                 kubernetes==24.2.0 requests==2.28.1 \
  && docker-compose --version \
  && echo "complete -C '/usr/bin/aws_completer' aws" >> ~/.bashrc \
  && aws --version
# install aws-iam-authenticator
RUN curl --silent --location --output /usr/local/bin/aws-iam-authenticator \
    https://s3.us-west-2.amazonaws.com/amazon-eks/1.21.2/2021-07-05/bin/linux/amd64/aws-iam-authenticator \
   && chmod +x /usr/local/bin/aws-iam-authenticator \
   && aws-iam-authenticator version
# install kubectl
RUN curl --tlsv1.3 --ssl-reqd --silent --location --output /usr/local/bin/kubectl \
     https://storage.googleapis.com/kubernetes-release/release/v1.23.7/bin/linux/amd64/kubectl \
  && chmod +x /usr/local/bin/kubectl \
  && kubectl version --client=true \
  && echo "source <(kubectl completion bash) \nalias k=kubectl \ncomplete -F __start_kubectl k" >> ~/.bashrc
# install kustomize
RUN kustomize_version="v4.5.4" \
  && curl --location \
    "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${kustomize_version}/kustomize_${kustomize_version}_linux_amd64.tar.gz" \
    | tar --extract --gzip \
  && install --target-directory=/usr/local/bin kustomize \
  && rm kustomize
# install gomplate
RUN curl --silent --location --output /usr/local/bin/gomplate \
    https://github.com/hairyhenderson/gomplate/releases/download/v3.8.0/gomplate_linux-amd64 \
   && chmod +x /usr/local/bin/gomplate \
   && gomplate --version
# install argo cli
RUN curl --silent --location \
      https://github.com/argoproj/argo-workflows/releases/download/v3.3.4/argo-linux-amd64.gz \
    | gzip -d > argo \
  && install --target-directory=/usr/local/bin argo \
  && rm argo
