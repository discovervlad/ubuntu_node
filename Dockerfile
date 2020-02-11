FROM ubuntu:rolling
ARG BUILD_DATE
ARG VCS_REF
ARG VCS_URL
ARG VERSION
ARG SVC_USER

##  Environment Variables
##  --------------------------------------------------------------------------------  ##
ENV NPM_CONFIG_LOGLEVEL=${NPM_CONFIG_LOGLEVEL:-info}  \
    SVC_USER=${SVC_USER:-node}

RUN groupadd --system --force --gid 1000 "${SVC_USER}" \
  && useradd --system --uid 1000 --gid "${SVC_USER}" --shell /bin/bash --create-home "${SVC_USER}" \
  && apt-get -q update --assume-yes \
  && apt-get install -y curl \
  && curl -sL https://deb.nodesource.com/setup_13.x | bash - \
  && apt-get install -y nodejs \
  && apt-get install --assume-yes --no-install-recommends gcc g++ make \
  && curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update && apt-get install yarn \
  && apt-get autoremove \
  && apt-get clean                   \
  && rm -rf /var/lib/apt/lists/*

USER ${SVC_USER}

## Set /usr/bin/node as the Dockerized entry-point Application
#ENTRYPOINT ["/usr/local/bin/node"];
