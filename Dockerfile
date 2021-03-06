FROM ubuntu:18.10

RUN apt-get update && apt-get install -y curl git zsh bash && apt-get clean

ENV DOTFILES_UNATTENDED=YES

ENTRYPOINT [ "/bin/sh" ]
