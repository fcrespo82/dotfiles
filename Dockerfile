FROM ubuntu:18.10

RUN apt-get update && apt-get install -y curl git zsh bash && apt-get clean

COPY . /root/dotfiles

ENV DOTFILES_DIR=/root/dotfiles

ENV DOTFILES_UNATTENDED=YES

RUN cd $DOTFILES_DIR && ./bootstrap.sh

ENTRYPOINT [ "/bin/zsh" ]