FROM debian:bullseye-slim
LABEL maintainer="Graham Ollis <plicease@cpan.org>"

ENV DEBIAN_FRONTEND noninteractive

RUN  echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf.d/00cip  \
  && apt-get update \
  && apt-get install --no-install-recommends \
       nano \
       zsh \
       bzip2 \
       ca-certificates \
       curl \
       dpkg-dev \
       gcc \
       libssl-dev \
       libc6-dev \
       make \
       netbase \
       patch \
       xz-utils \
       zlib1g-dev \
       pkg-config \
       less \
       git \
       libffi-dev \
       libarchive-dev \
       file \
       dos2unix \
  && apt-get -q autoremove \
  && apt-get -q clean \
  && rm -rf /var/lib/apt/lists/*

ENV TZ America/Denver
ENV PERL_CPANM_OPT --no-man-pages

RUN groupadd -g 1000 atn
RUN useradd -u 1000 -g 1000 -m -s /bin/zsh atn

USER atn

WORKDIR /home/atn

RUN curl https://raw.githubusercontent.com/tokuhirom/Perl-Build/master/perl-build | perl - 5.34.0 /home/atn/opt/perl/5.34.0/
RUN curl https://cpanmin.us | /home/atn/opt/perl/5.34.0/bin/perl - App::cpanminus && rm -rf ~/.cpanm
RUN cd opt/perl && ln -s 5.34.0 .path

RUN echo "user PLICEASE" > /home/atn/.pause                  \
 && echo "password fixme" >> /home/atn/.pause                \
 && touch /home/atn/.zlocalenv

RUN mkdir ~/dev                                              \
 && cd ~/dev                                                 \
 && git clone --depth 2 https://github.com/plicease/zsh.git  \
 && cd zsh                                                   \
 && rm -rf .git                                              \
 && cd install                                               \
 && ./install.zsh

CMD zsh

