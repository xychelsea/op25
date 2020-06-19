# OP25

Forked from [boatbod/op25](git://github.com/boatbod/op25) "master" branch on June 19, 2020

Updated June 19, 2020

## Installation

These high level instructions will lead you through installing op25 and liquidsoap
on any Debian based Linux system. It is geared towards the Raspberry Pi3B which is
inexpensive but yet just powerful enough to receive, decode and stream P25 trunked
radio system utilizing either Phase 1 or Phase 2 audio codecs.

It is possible to configure and use OP25 with other streaming software (such as Darkice)
but this setup has the advantage of completely avoiding use of the ALSA sound subsystem
with has proven itself to be someway quirky and prone to problems particularly when using
the loopback driver (aloop).

There are many refinements which should be made to these instructions, particularly how
to configure liquidsoap and op25 to properly auto-start at boot time.

### Build Prerequisites

```bash
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
```

### OP25

```bash
git clone git://github.com/xychelsea/op25
cd op25
./install.sh 
```

### GNUPlot-X11

This optional package enables you to see nice graphs within X11 windowing systems.

```bash
sudo apt-get install gnuplot-x11
```

### liquidsoap

This package enables the liquidsoap audio and video streaming language.

```bash
sudo apt-get install liquidsoap
```

### PulseAudio

PulseAudio is optional, but preferred over default alsa.

```bash
sudo apt-get install pulseaudio pulseaudio-utils
```

### Icecast

The Icecast server is optional

```bash
sudo apt-get install icecast2

```
Follow prompts and set up appropriate passwords. Then, using your favorite text editor, you insert something like this XML snippet:

```xml
<!-- You may have multiple <listener> elements -->
 <listen-socket>
  <port>8000</port>
  <shoutcast-mount>/op25</shoutcast-mount>
</listen-socket>
```

### GQRX

```bash
sudo apt-get install gqrx-sdr
```

## Configuration

Set up rx.py command line options, trunk.tsv, meta.json and other files necessary to
make a working instance of op25. Edit op25.liq to configure local sound options and/or
streaming to icecast server.

## Run OP25 and liquidsoap

The screen tool can enable you to detach terminal screens.

Terminal #1:

```bash
cd ~/op25/op25/gr-op25_repeater/apps
./rx.py --nocrypt --args "rtl=0" --gains 'lna:36' -S 57600 -q 0 -d 0 -v 1 -2 -T trunk.tsv -V -w -M meta.json 2> stderr.2
```

(In particular note the new -w parameter, that allows liquid to connect)

Terminal #2:

```bash
cd ~/op25/op25/gr-op25_repeater/apps
./op25.liq
```

Terminal #3:
```bash
cd ~/op25/op25/gr-op25_repeater/apps
tail -f stderr.2
```

### Making liquidsoap and op25 start automatically at boot

Automatically starting liquidsoap and op25 at boot time is best handled using
the systemd services manager "systemctl".  Two service scripts are required, and
although examples are provided, these should best be edited/customized to match
your exact environment.  As written they assume /home/pi is the home directory
which may or may not be the case...

You will also need to edit op25.sh (started by op25-rx.service) to have the command line parameters that you normally use to start rx.py

Another factor to consider is that op25 should only be auto-started at boot
time when it has been configured for the http terminal type.  Auto-starting
the default curses terminal is not going to be successful. An example of this is to add -l http:127.0.0.1:12345

First copy the two service files into /etc/systemd/system:

```bash
sudo cp ~/op25/op25/gr-op25_repeater/apps/op25-liq.service /etc/systemd/system
sudo cp ~/op25/op25/gr-op25_repeater/apps/op25-rx.service /etc/systemd/system
```

Next enable and then start the two services:

```bash
sudo systemctl enable op25-liq op25-rx
sudo systemctl start op25-liq op25-rx
```

You can subsequently stop the services by issuing the following command:

sudo systemctl stop op25-rx
or
sudo systemctl stop op25-rx op25-liq

### Icecast2 low-latency setups (optional)

Buffering may cause the stream to lag behind the metadata.
To decrease latency for low-latency environments, such as 
highspeed networks, edit /etc/icecast2/icecast.xml to 
disable Icecast2 burst-on-connect and reduce burst-size.

sudo vi /etc/icecast2/icecast.xml

<!-- If enabled, this will provide a burst of data when a client
	 first connects, thereby significantly reducing the startup
	 time for listeners that do substantial buffering. However,
	 it also significantly increases latency between the source
	 client and listening client.  For low-latency setups, you
	 might want to disable this. -->
<burst-on-connect>0</burst-on-connect>
<!-- same as burst-on-connect, but this allows for being more
	 specific on how much to burst. Most people won't need to
	 change from the default 64k. Applies to all mountpoints  -->
<burst-size>0</burst-size>



## Hardware Requirements

To run OP25 with software-defined radio, you will need an SDR "dongle" with antannae that plugs into your desktop, laptop, or Raspberry Pi USB port. You can usually purchase one of several SDR kits for under $30

## Raspberry Pi

Raspberry Pi 3B+ or newer is recommended. Using a Raspberry Pi Zero, with a single processor core, can take a few hours to compile and install. OP25 does run on a Raspberry Pi Zero, but not very efficiently.

## OP25 Software Stack

Our OP25 Code fork on Github https://github.com/AaronSwartzDay-SSP/op25
GNU Radio source https://github.com/gnuradio/gnuradio
Mac install: https://wiki.gnuradio.org/index.php/MacInstall
PC install: https://wiki.gnuradio.org/index.php/WindowsInstall
Debian package for testing: https://github.com/AaronSwartzDay-SSP/op25/tree/master/debian
The SDR Linux Distro for Raspberry Pi
A modified Raspbian image with the latest SDR software pre-installed and ready to go. Compatible with every Raspberry Pi.(Pre-built Raspberry Pi Image with GNURadio and these software radio tools: SDR Angel, Soapy Remote, GQRX, GNURadio, LimeUtil, and LimeVNA)Note: When you use this, you still have to compile/install op25, but this can be completed successfully and easily on pi3 with install script.
https://pisdr.luigifreitas.me
All Your SDR Software In A Handy Raspberry Pi Image, by Jenny List for Hackaday (goes with SDR Linux Distro for Raspberry Pi below)
https://hackaday.com/2019/12/20/all-your-sdr-software-in-a-handy-raspberry-pi-image/
GQRX (During testing, we used gqrx to verify the dongle was working and to check for p25 traffic. This was *before* we started trying to use GNURadio w/OP25 installed.)
Gqrx is an open source software defined radio receiver (SDR) powered by the GNU Radio and the Qt graphical toolkit. Gqrx supports many of the SDR hardware available, including Airspy, Funcube Dongles, rtl-sdr, HackRF and USRP devices. See supported devices for a complete list. https://gqrx.dk/download
DragonOS LTS – an out-of-the-box Lubuntu 18.04 based x86_64 operating system for anyone interested in software defined radios. https://sourceforge.net/projects/dragonos-lts/
Docker install: https://github.com/lysol/op25-docker

Installation
-----


- Installation notes from testing at [Noisebridge](https://www.noisebridge.net/OP25)
- Osmocom OP25 [install instructions](https://osmocom.org/projects/op25/wiki/InstallInstructionsPage)
- All Your SDR Software In A [Handy Raspberry Pi Image](https://hackaday.com/2019/12/20/all-your-sdr-software-in-a-handy-raspberry-pi-image/), by Jenny List for Hackaday (goes with SDR Linux Distro for Raspberry Pi below)



Troubleshooting Info
- OP25 “Q & A” page
https://osmocom.org/projects/op25/wiki/QandAs

- OP25 overview of bugs and features
https://osmocom.org/projects/op25

- OP25 task list
https://osmocom.org/projects/op25/wiki

Issue: rtl modules not showing up in gnuradio directory (installing to the wrong directory)
Fix:

Photo of Plotting: “We also got plotting working, which makes the reception audible too” (which program is that?)

## Resources

### Tutorials

- [OP25 For Dummies](https://www.hagensieker.com/wordpress/2018/07/17/op25-for-dummies/) – Or how to build a police scanner for $30 (Part 1)
- Trunked Radio: [A Guide](https://www.andrewmohawk.com/2020/06/12/trunked-radio-a-guide/) (June 12, 2020) by Andrew Nohawk
- [Introductory Tour of the GNU Radio Project](http://www.joshknows.com/gnuradio), by Josh Blum
- [GNU Radio Companion](https://wiki.gnuradio.org/index.php/Guided_Tutorial_GRC)

### Background on Software Defined Radio

- [Wikipedia Article](https://en.wikipedia.org/wiki/Software-defined_radio#RTL-SDR) on SDR (Software Defined Radio)
- [SDR demonstration](http://websdr.ewi.utwente.nl:8901/) (Wide-band WebSDR) from the amateur radio club ETGD at the University of Twentem in the Netherlands 

Specific

APCO P25 Security Revisited – The Practical Attacks! – Matt Robert (Security analysis and tips from one of the founders of the OP25 dev list
https://www.youtube.com/watch?v=OumDnhO7veg

World’s cheapest P25 receiver w/ decryption: GNU Radio + OP25 + $20 RTL2832 DVB-T Dongle (recommended by OP25 list) 
https://youtu.be/wShOLgW2tmI

Introduction to P25 – Radio Academy
https://www.taitradioacademy.com/topic/benefits-of-p25-1/

Mapping BER and Signal Strength of P25 Radio SystemsS412E LMR Master (Anritsu.com)
https://dl.cdn-anritsu.com/en-us/test-measurement/files/Application-Notes/Application-Note/11410-00508C.pdf

### Standards
- APCO International’s Project 25 (P25) Page (APCO = Association of Public-Safety Communications Officials International, Inc.)
https://www.apcointl.org/spectrum-management/spectrum-management-resources/interoperability/p25/

- APCO International’s Project 25 Organizational Overview
https://www.apcointl.org/spectrum-management/spectrum-management-resources/interoperability/p25/p25-organizational-overview/

- Steering Committee Approved P25 Standards Document list June 2019
http://www.project25.org/images/stories/ptig/P25_SC_19-06-002-R1_Approved_P25_TIA_Standards_-_June_2019.pdf

- Project 25’s Statement of Requirements (approved in 2013)
http://project25.org/images/stories/ptig/docs/Technical_Documents/12131211_Approved_P25_SoR_12-11-13.pdf


OP25 dev list sample page
https://osmocom.org/projects/op25/wiki/SamplesPage

Sigidwiki.com Signal Identification Guide
https://www.sigidwiki.com/wiki/Project_25_(P25)#Audio_Samples

Samples from the osmocom developer website
http://people.osmocom.org/laforge/tmp/p25-samples/

OP25 Flow Graph
http://svn.spench.net/main/gr-baz/samples/OP25.grc

OP25 Decoder Block Flow Graph
https://wiki.spench.net/wiki/Gr-baz#op25

Sample GRC flowgraphs demonstrating the use of some of the above blocks
https://wiki.spench.net/wiki/Gr-baz#samples

OP25 Wikis
Sound file of coded audio (perhaps create a longer one?)

OP25 ad-hoc working group (they wrote OP25)
https://osmocom.org/projects/op25/wiki

Sigidwiki.com Signal Identification Guide
https://www.sigidwiki.com/wiki/Project_25_(P25)

APCO-25 Page on RadioReference Wiki: https://wiki.radioreference.com/index.php/APCO_Project_25

Project 25 (P25 or APCO-25) on wikipedia: https://en.wikipedia.org/wiki/Project_25

 

OP25 Developer Mailing List Archives
OP25 Mailing list archives: https://lists.osmocom.org/pipermail/op25-dev/

OP25 Mailing list archives by subject: https://lists.osmocom.org/pipermail/op25-dev/2012/subject.html

### Other Resources

Websites for looking up frequencies for a given geographical area

- [The Radio Reference Database](https://www.radioreference.com/apps/db/) (United States)