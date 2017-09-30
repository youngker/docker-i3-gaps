FROM ubuntu:17.10
MAINTAINER YoungJoo Lee "youngker@gmail.com"

ARG DEBIAN_FRONTEND=noninteractive

RUN cd /etc/apt && \
    sed -i 's/archive.ubuntu.com/ftp.daum.net/g' sources.list

RUN echo 'APT::Install-Recommends "0";\nAPT::Install-Suggests "0";' > /etc/apt/apt.conf

RUN apt-get update && apt-get install -y \
    ca-certificates \
    compton \
    conky \
    curl \
    dbus-x11 \
    dunst \
    feh \
    fontconfig \
    git \
    libasound2 \
    libcairo2 \
    libev4 \
    libiw30 \
    libmpdclient2 \
    libnotify-bin \
    libpangocairo-1.0-0 \
    libxcb-cursor0 \
    libxcb-ewmh2 \
    libxcb-icccm4 \
    libxcb-keysyms1 \
    libxcb-randr0 \
    libxcb-xinerama0 \
    libxcb-xkb1 \
    libxcb-xrm0 \
    libxkbcommon-x11-0 \
    libyajl2 \
    locales \
    psmisc \
    rofi \
    rxvt-unicode-256color \
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
 && cd /tmp && \
    git clone https://github.com/lucy/tewi-font.git && cd tewi-font && \
    make && cp -rp out/ /usr/share/fonts/bitmap && \
    wget --no-check-certificate -qO - https://github.com/stark/siji/raw/master/pcf/siji.pcf | gzip -c > siji.pcf.gz && \
    cp siji.pcf.gz /usr/share/fonts/bitmap && fc-cache -fv \
 && cd /tmp && \
    wget --no-check-certificate https://github.com/neutrinolabs/xrdp/releases/download/v0.9.3.1/xrdp-0.9.3.1.tar.gz && \
    tar xvzf xrdp-0.9.3.1.tar.gz && \
    cd xrdp-0.9.3.1 && ./configure && make && make install \
 && cd /tmp && \
    wget --no-check-certificate https://github.com/neutrinolabs/xorgxrdp/releases/download/v0.2.3/xorgxrdp-0.2.3.tar.gz && \
    tar xvzf xorgxrdp-0.2.3.tar.gz && \
    cd xorgxrdp-0.2.3 && ./configure && make && make install \
 && cd /tmp && git clone https://www.github.com/Airblader/i3 i3-gap && cd i3-gap && \
    autoreconf --force --install && \
    rm -rf build/ && \
    mkdir -p build && cd build && \
    ../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers && \
    make && make install \
 && cd /tmp && \
    wget --no-check-certificate https://launchpad.net/ubuntu/+archive/primary/+files/xcb-proto_1.11.orig.tar.gz && \
    tar xvzf xcb-proto_1.11.orig.tar.gz && \
    wget --no-check-certificate https://launchpad.net/ubuntu/+archive/primary/+files/xcb-proto_1.11-1.diff.gz && \
    gzip -d xcb-proto_1.11-1.diff.gz && cd xcb-proto-1.11 && \
    patch -p1 < ../xcb-proto_1.11-1.diff && ./configure && make && make install \
 && cd /tmp && \
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
 && rm -rf /var/lib/apt/lists/* /tmp/*

RUN git clone https://github.com/youngker/dotfiles /etc/skel/.dotfiles && \
    rm /etc/skel/.bashrc && rm /etc/fonts/conf.d/70-no-bitmaps.conf

COPY etc/ /etc/
ADD images/wallpaper1.jpg /usr/share/backgrounds/wallpaper1.jpg
ADD images/wallpaper2.jpg /usr/share/backgrounds/wallpaper2.jpg

RUN useradd -s /bin/bash -m docker && \
    echo "docker:docker" | chpasswd && \
    echo "docker ALL=(ALL) ALL" > /etc/sudoers.d/docker && \
    chmod 0440 /etc/sudoers.d/docker

run chown -R docker:docker /home/docker

RUN echo 'allowed_users = anybody' > /etc/X11/Xwrapper.config
run sed -i 's/^\(\[supervisord\]\)$/\1\nnodaemon=true/' /etc/supervisor/supervisord.conf
cmd ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
