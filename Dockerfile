FROM docker:23.0.5-dind
ENV TZ=UTC
RUN apk update \
  && apk add python3-dev py3-pip rust libffi-dev openssl-dev gcc libc-dev make \
             curl wget bash git sqlite jq cargo parallel \
  && echo "source /etc/profile" >> ~/.bashrc
RUN pip3 install --upgrade pip
# install docker-compose and AWS tools
RUN pip3 install --ignore-installed \
                 docker-compose==1.29.2 awscli==1.27.120 \
                 kubernetes==26.1.0 requests==2.28.2 \
  && docker-compose --version \
  && echo "complete -C '/usr/bin/aws_completer' aws" >> ~/.bashrc \
  && aws --version
# install aws-iam-authenticator
RUN curl --silent --location --output /usr/local/bin/aws-iam-authenticator \
    https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.6.2/aws-iam-authenticator_0.6.2_linux_amd64 \
   && chmod +x /usr/local/bin/aws-iam-authenticator \
   && aws-iam-authenticator version
# install kubectl
RUN curl --tlsv1.3 --ssl-reqd --silent --location --output /usr/local/bin/kubectl \
     https://storage.googleapis.com/kubernetes-release/release/v1.26.4/bin/linux/amd64/kubectl \
  && chmod +x /usr/local/bin/kubectl \
  && kubectl version --client=true \
  && echo "source <(kubectl completion bash) \nalias k=kubectl \ncomplete -F __start_kubectl k" >> ~/.bashrc
# install kustomize
RUN kustomize_version="v4.5.7" \
  && curl --location \
    "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${kustomize_version}/kustomize_${kustomize_version}_linux_amd64.tar.gz" \
    | tar --extract --gzip \
  && install --target-directory=/usr/local/bin kustomize \
  && rm kustomize
# install gomplate
RUN curl --silent --location --output /usr/local/bin/gomplate \
    https://github.com/hairyhenderson/gomplate/releases/download/v3.11.5/gomplate_linux-amd64 \
   && chmod +x /usr/local/bin/gomplate \
   && gomplate --version
# install argo cli
RUN curl --silent --location \
      https://github.com/argoproj/argo-workflows/releases/download/v3.4.7/argo-linux-amd64.gz \
    | gzip -d > argo \
  && install --target-directory=/usr/local/bin argo \
  && rm argo
