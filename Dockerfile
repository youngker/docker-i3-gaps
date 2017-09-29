FROM ubuntu:17.10
MAINTAINER YoungJoo Lee "youngker@gmail.com"

ARG DEBIAN_FRONTEND=noninteractive

ENV XRDP_PKG xrdp-0.9.3.1
ENV XORG_PKG xorgxrdp-0.2.3

RUN cd /etc/apt && \
    sed -i 's/archive.ubuntu.com/ftp.daum.net/g' sources.list

RUN echo 'APT::Install-Recommends "0";\nAPT::Install-Suggests "0";' > /etc/apt/apt.conf

RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    dbus-x11 \
    git \
    libasound2 \
    libcairo2 \
    libev4 \
    libiw30 libxcb-xkb1 \
    libmpdclient2 \
    libpangocairo-1.0-0 \
    libxcb-cursor0 \
    libxcb-ewmh2 \
    libxcb-icccm4 \
    libxcb-keysyms1 \
    libxcb-randr0 \
    libxcb-xinerama0 \
    libxcb-xrm0 \
    libxkbcommon-x11-0 \
    libyajl2 \
    locales \
    rxvt-unicode \
    stow \
    sudo \
    supervisor \
    tzdata \
    wget \
    xorg \
 && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    autoconf \
    automake \
    build-essential \
    clang \
    cmake \
    cmake-data \
    file \
    libasound2-dev \
    libcairo2-dev \
    libcurl4-openssl-dev \
    libev-dev \
    libiw-dev \
    libjsoncpp-dev \
    libmpdclient-dev \
    libpam0g-dev \
    libpango1.0-dev \
    libssl-dev \
    libstartup-notification0-dev \
    libxcb-cursor-dev \
    libxcb-ewmh-dev \
    libxcb-icccm4-dev \
    libxcb-image0-dev \
    libxcb-keysyms1-dev \
    libxcb-randr0-dev \
    libxcb-util0-dev \
    libxcb-xinerama0-dev \
    libxcb-xkb-dev \
    libxcb-xrm-dev \
    libxcb-xrm0 \
    libxcb1-dev \
    libxfixes-dev \
    libxfont1-dev \
    libxkbcommon-dev \
    libxkbcommon-x11-dev \
    libxrandr-dev \
    libyajl-dev \
    nasm \
    pkg-config \
    python-xcbgen \
    xserver-xorg-dev \
 && cd / && \
    wget --no-check-certificate https://github.com/neutrinolabs/xrdp/releases/download/v0.9.3.1/$XRDP_PKG.tar.gz && \
    tar xvzf $XRDP_PKG.tar.gz && \
    cd $XRDP_PKG && ./configure && make && make install && cd / && \
    rm -f $XRDP_PKG.tar.gz && rm -rf $XRDP_PKG \
 && cd / && \
    wget --no-check-certificate https://github.com/neutrinolabs/xorgxrdp/releases/download/v0.2.3/$XORG_PKG.tar.gz && \
    tar xvzf $XORG_PKG.tar.gz && \
    cd $XORG_PKG && ./configure && make && make install && cd / && \
    rm -f $XORG_PKG.tar.gz && rm -rf $XORG_PKG \
 && cd / && git clone https://www.github.com/Airblader/i3 i3-gap && cd i3-gap && \
    autoreconf --force --install && \
    rm -rf build/ && \
    mkdir -p build && cd build && \
    ../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers && \
    make && make install \
 && cd / && \
    wget --no-check-certificate https://launchpad.net/ubuntu/+archive/primary/+files/xcb-proto_1.11.orig.tar.gz && \
    tar xvzf xcb-proto_1.11.orig.tar.gz && \
    wget --no-check-certificate https://launchpad.net/ubuntu/+archive/primary/+files/xcb-proto_1.11-1.diff.gz && \
    gzip -d xcb-proto_1.11-1.diff.gz && cd xcb-proto-1.11 && \
    patch -p1 < ../xcb-proto_1.11-1.diff && ./configure && make && make install \
 && cd / && \
    git clone --recursive https://github.com/jaagr/polybar && cd polybar && \
    mkdir build && cd build && \
    cmake -DCMAKE_C_COMPILER="clang" -DCMAKE_CXX_COMPILER="clang++"  .. && make install \
 && apt-get remove -y \
    autoconf \
    automake \
    build-essential \
    clang \
    cmake \
    cmake-data \
    file \
    libasound2-dev \
    libcairo2-dev \
    libcurl4-openssl-dev \
    libev-dev \
    libiw-dev \
    libjsoncpp-dev \
    libmpdclient-dev \
    libpam0g-dev \
    libpango1.0-dev \
    libssl-dev \
    libstartup-notification0-dev \
    libxcb-cursor-dev \
    libxcb-ewmh-dev \
    libxcb-icccm4-dev \
    libxcb-image0-dev \
    libxcb-keysyms1-dev \
    libxcb-randr0-dev \
    libxcb-util0-dev \
    libxcb-xinerama0-dev \
    libxcb-xkb-dev \
    libxcb-xrm-dev \
    libxcb-xrm0 \
    libxcb1-dev \
    libxfixes-dev \
    libxfont1-dev \
    libxkbcommon-dev \
    libxkbcommon-x11-dev \
    libxrandr-dev \
    libyajl-dev \
    nasm \
    pkg-config \
    python-xcbgen \
    xserver-xorg-dev \
 && apt-get -y autoremove \
 && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/youngker/dotfiles /etc/skel/.dotfiles && rm /etc/skel/.bashrc

RUN echo 'allowed_users = anybody' > /etc/X11/Xwrapper.config

RUN useradd -s /bin/bash -m docker && \
    echo "docker:docker" | chpasswd && \
    echo "docker ALL=(ALL) ALL" > /etc/sudoers.d/docker && \
    chmod 0440 /etc/sudoers.d/docker

COPY home/ /home/
COPY etc/ /etc/

run chown -R docker:docker /home/docker

run sed -i 's/^\(\[supervisord\]\)$/\1\nnodaemon=true/' /etc/supervisor/supervisord.conf
cmd ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
