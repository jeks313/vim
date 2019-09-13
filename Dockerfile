# Dockerfile for dev environment

FROM ubuntu
MAINTAINER Christopher Hyde <chris@hyde.ca>
RUN apt-get update && apt-get install -y \
 ack-grep \
 bzr \
 cmake \
 curl \
 g++ \
 git \
 make \
 man-db \
 ncurses-dev \
 procps \
 python-dev \
 python-pip \
 software-properties-common python-software-properties \
 ssh \
 sudo \
 unzip \
 xz-utils

# vim install from source
RUN apt-get install -y \
    build-essential \
    liblua5.3-0 \
    liblua5.3-dev \
    python-dev \
    python3-dev \
    ruby-dev \
    libperl-dev \
    libncurses5-dev \
    libgnome2-dev \
    libgnomeui-dev \
    libgtk2.0-dev \
    libatk1.0-dev \
    libbonoboui2-dev \
    libcairo2-dev \
    libx11-dev \
    libxpm-dev \
    libxt-dev

RUN mkdir /usr/include/lua5.3/include && mkdir /usr/include/lua5.3/lib && \
    cp /usr/include/lua5.3/*.h /usr/include/lua5.3/include/ && \
    ln -sf /usr/lib/x86_64-linux-gnu/liblua5.3.so /usr/include/lua5.3/lib/liblua.so && \
    ln -sf /usr/lib/x86_64-linux-gnu/liblua5.3.a /usr/include/lua5.3/lib/liblua.a

RUN cd /tmp && git clone https://github.com/vim/vim.git && cd vim && git checkout v8.0.0503 && make distclean

RUN cd /tmp/vim && ./configure --with-features=huge \
            --enable-rubyinterp \
            --enable-largefile \
            --disable-netbeans \
            --enable-python3interp \
            --enable-perlinterp \
            --enable-luainterp \
            --enable-gui=auto \
            --enable-fail-if-missing \
            --with-lua-prefix=/usr/include/lua5.3 \
            --enable-cscope \
            --enable-multibyte \
            --enable-python3interp \
            --with-python3-config-dir=$(python3-config --configdir) \ 
            --enable-pythoninterp \
            --with-python-config-dir=$(python-config --configdir) && make && make install

#COPY bashrc /root/.bashrc

RUN mkdir /installs
# Install Golang1.4.2
RUN cd /installs && wget https://dl.google.com/go/go1.13.linux-amd64.tar.gz
RUN cd /usr/local && tar -zxvf /installs/go1.13.linux-amd64.tar.gz

# Vundle: Vim plugin manager
RUN git clone https://github.com/gmarik/Vundle.vim.git /root/.vim/bundle/Vundle.vim

ENV GOPATH /go
ENV GOBIN /usr/local/go/bin
ENV PATH /usr/local/go/bin:/go/bin$PATH
ENV HOME /root
ENV TERM xterm-256color
WORKDIR /go/src

# VIM
COPY vimrc /root/.vimrc
RUN vim --not-a-term +PluginInstall +qall
RUN echo "===> get vim-go binaries..." \
  && go get github.com/nsf/gocode \
  && go get github.com/klauspost/asmfmt/cmd/asmfmt \
  && go get github.com/kisielk/errcheck \
  && go get github.com/davidrjenni/reftools/cmd/fillstruct \
  && go get github.com/rogpeppe/godef \
  && go get github.com/zmb3/gogetdoc \
  && go get golang.org/x/tools/cmd/goimports \
  && go get github.com/golang/lint/golint \
  && go get github.com/alecthomas/gometalinter \
  && go get github.com/fatih/gomodifytags \
  && go get golang.org/x/tools/cmd/gorename \
  && go get github.com/jstemmer/gotags \
  && go get golang.org/x/tools/cmd/guru \
  && go get github.com/josharian/impl \
  && go get github.com/dominikh/go-tools/cmd/keyify \
  && go get github.com/fatih/motion \
  && go get golang.org/x/sync/syncmap \
  && go get github.com/satori/go.uuid \
  && go get github.com/prometheus/client_golang/prometheus/promhttp \
  && go get github.com/prometheus/client_golang/prometheus \
  && go get github.com/nytlabs/gojee \
  && go get github.com/joho/godotenv \
  && go get github.com/jmoiron/sqlx \
  && go get github.com/jessevdk/go-flags \
  && go get github.com/hashicorp/consul/api \
  && go get github.com/smartystreets/goconvey/convey \
  && go get github.com/go-sql-driver/mysql \
  && go get -u github.com/cweill/gotests/... \
  && gometalinter --install

RUN cd ~/.vim/bundle/command-t/ruby/command-t/ext/command-t && ruby extconf.rb && make
RUN apt-get install -y ctags

# Change timezone
RUN ln -sf /usr/share/zoneinfo/America/Vancouver /etc/localtime

# tmux
RUN apt-get install -y tmux
COPY tmux.conf /root/.tmux.conf

# go packages
RUN echo "===> installing common go packges" \
    && go get github.com/nsqio/go-nsq \
    && go get github.com/sirupsen/logrus \
    && go get github.com/ziutek/mymysql/godrv \
    && go get github.com/urfave/negroni \
    && go get github.com/gorilla/mux
    
# zsh
RUN apt-get install --reinstall locales && localedef --force --inputfile=en_US --charmap=UTF-8 --alias-file=/usr/share/locale/locale.alias en_US.UTF-8
RUN apt-get install -y zsh && \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" || true
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting
RUN mkdir -p /root/dotfiles
COPY zsh /root/dotfiles/zsh
COPY zshrc /root/.zshrc

RUN git config --global user.email "chris.hyde@fusemail.com"
RUN git config --global user.name "Christopher Hyde"


CMD ["/bin/zsh"]

# Run Docker with
# sudo docker run -i -t -v ~/workspace/src:/go/src testing2
