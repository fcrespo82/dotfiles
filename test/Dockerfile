FROM ubuntu:18.10

COPY . /dotfiles

RUN cd /dotfiles && ./bootstrap.sh y

RUN zsh

RUN dotfiles-update