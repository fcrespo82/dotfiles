FROM ubuntu:18.10

RUN apt-get update && apt-get install -y curl git zsh bash && apt-get clean

# COPY ./tools/install.sh /root/install.sh

ENV DOTFILES_UNATTENDED=YES

ENTRYPOINT [ "/bin/zsh" ]