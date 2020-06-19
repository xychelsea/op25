#! /bin/sh

# op25 install script for debian based systems

if [ ! -d op25/gr-op25 ]; then
	echo ====== error, op25 top level directories not found
	echo ====== you must change to the op25 top level directory
	echo ====== before running this script
	exit
fi

sudo apt-get update
sudo apt-get build-dep gnuradio
sudo apt-get install \
	build-essential \
	cmake \
	doxygen \
	git \
	gnuradio \
	gnuradio-dev \
	gnuplot-x11 \
	gr-osmosdr \
	libhackrf-dev \
	libitpp-dev \
	libpcap-dev \
	librtlsdr-dev \
	libuhd-dev \
	pkg-config \
	python-numpy \
	python-requests \
	python-waitress \
	swig

if [ ! -f /etc/modprobe.d/blacklist-rtl.conf ]; then
	echo ====== installing blacklist-rtl.conf
	echo ====== please reboot before running op25
	sudo install -m 0644 ./blacklist-rtl.conf /etc/modprobe.d/
fi

mkdir build
cd build
cmake ../
make
sudo make install
sudo ldconfig
