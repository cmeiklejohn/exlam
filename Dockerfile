FROM amazonlinux:2017.03.1.20170812

MAINTAINER Christopher S. Meiklejohn <christopher.meiklejohn@gmail.com>

RUN cd /tmp && \
    yum -y install gcc gcc-c++ glibc-devel make ncurses-devel openssl-devel autoconf java-1.8.0-openjdk-devel git wget automake

RUN cd /tmp && \
    wget https://www.openssl.org/source/openssl-1.0.2h.tar.gz && \
    tar -xvzf openssl-1.0.2h.tar.gz && \
    cd openssl-1.0.2h/ && \
    ./config --prefix=/usr/local shared -fPIC && \
    make depend && \
    make && \
    make install
    
RUN cd /tmp && \
    wget http://erlang.org/download/otp_src_19.3.tar.gz && \
    tar -zxvf otp_src_19.3.tar.gz && \
    cd otp_src_19.3 && \
    ./configure --prefix /opt/erlang --disable-dynamic-ssl-lib --with-ssl=/usr/local --enable-smp-support --without-termcap --enable-dirty-schedulers --enable-builtin-zlib && \
    make && \
    make install && \
    ln -s /opt/erlang/bin/erl /usr/bin/erl && \
    ln -s /opt/erlang/bin/erlc /usr/bin/erlc && \
    ln -s /opt/erlang/bin/escript /usr/bin/escript && \
    ln -s /opt/erlang/bin/epmd /usr/bin/epmd

RUN cd /tmp && \
    mkdir /opt/elixir && \
    git clone https://github.com/elixir-lang/elixir.git /opt/elixir && \
    cd /opt/elixir && \
    make && \
    ln -s /opt/elixir/bin/iex /usr/bin/iex && \
    ln -s /opt/elixir/bin/mix /usr/bin/mix && \
    ln -s /opt/elixir/bin/elixir /usr/bin/elixir && \
    ln -s /opt/elixir/bin/elixirc /usr/bin/elixirc

RUN export PATH=~/.local/bin:$PATH && \
    cd /tmp && \
    yum -y install python-pip && \
    python-pip install awscli --upgrade --user

RUN cd /tmp && \
    curl --silent --location https://rpm.nodesource.com/setup_4.x | bash - && \
    yum -y install zip vim

RUN cd /tmp && \
    wget https://nodejs.org/download/release/v6.10.0/node-v6.10.0-linux-x64.tar.gz && \
    tar -zxvf node-v6.10.0-linux-x64.tar.gz && \
    mv node-v6.10.0-linux-x64 /opt/node && \
    ln -s /opt/node/bin/node /usr/bin/node

RUN export PATH=~/.local/bin:$PATH && \
    cd /tmp && \
    git clone https://github.com/cmeiklejohn/exlam.git && \ 
    cd exlam && \
    mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    mix compile && \
    mkdir -p /var/task && \
    git pull && \
    ln -s /tmp/exlam/deploy/burn/ /var/task/burn

RUN export PATH=~/.local/bin:$PATH && \
    cd /tmp/exlam && \
    mix release.init && \
    mix exlam.init

COPY .aws /root/.aws
COPY deploy/config.exs /tmp/exlam/deploy/config.exs
COPY config/config.exs /tmp/exlam/config/config.exs

RUN export PATH=~/.local/bin:$PATH && \
    cd /tmp/exlam && \
    make delete-function && \
    mix exlam.package && \
    mix exlam.deploy -cli

CMD export PATH=~/.local/bin:$PATH && \
    cd /tmp/exlam && \
    git pull && \
    make clean && \
    make && \
    make delete-function && \
    mix exlam.package && \
    mix exlam.deploy -cli && \
    /bin/bash