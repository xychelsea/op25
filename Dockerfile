FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
ARG TZ=UTC

RUN cd / && \
    export DEBIAN_FRONTEND=noninteractive && \
    export TZ=$TZ && \
    apt-get update && \
    apt-get install -y tzdata && \
    dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get update && \
    apt-get install -y \
    build-essential \
    cmake \
    doxygen \
    git \
    gnuplot-x11 \
    gnuradio \
    gnuradio-dev \
    gr-osmosdr \
    libhackrf-dev \
    libitpp-dev \
    libpcap-dev \
    librtlsdr-dev \
    libuhd-dev \
    pkg-config \
    python-numpy \
    swig

RUN git clone git://github.com/xychelsea/op25 && \
    cd /op25 && \
    mkdir build && \
    cd build && \
    cmake ../ && \
    make && \
    make install && \
    ldconfig

#COPY ./config/ /op25/op25/gr-op25_repeater/apps/
#COPY ./rx.sh /rx.sh
