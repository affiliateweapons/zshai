FROM       alpine
MAINTAINER zsh.ai

RUN           apk update \
           && apk upgrade \
           && apk add figlet \
           && apk add lolcat \
           #
           # clean up cached artefacts
           && rm -rf /var/cache/apk/*

ENTRYPOINT ["/bin/bash -c"]
