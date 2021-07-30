FROM ubuntu:20.04
LABEL maintainer="bruno.vilaca.sa@gmail.com"
USER root

# Install clang format 12.0.0
RUN apt-get update && apt-get install -y clang-format-12

# Install cppchecker 2.4.1

RUN apt-get update
RUN apt-get install -y build-essential libpcre3 libpcre3-dev python3 python3-pip wget

RUN wget -O /tmp/cppcheck-2.4.1.tar.gz https://github.com/danmar/cppcheck/archive/2.4.1.tar.gz
RUN cd /tmp/ && tar xvzf cppcheck-2.4.1.tar.gz

RUN cd /tmp/cppcheck-2.4.1 && make install FILESDIR=/usr/bin/cfg HAVE_RULES=yes

# Install scan build

RUN pip install scan-build

# Start from a Bash prompt
#CMD ["/bin/bash"]