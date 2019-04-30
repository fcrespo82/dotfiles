FROM alpine:latest

RUN apk add --no-cache curl git zsh bash

COPY . /root/dotfiles

ENV DOTFILES_DIR=/root/dotfiles

ENV DOTFILES_UNATTENDED=YES

RUN cd $DOTFILES_DIR && ./bootstrap.sh

ENTRYPOINT [ "/bin/zsh" ]