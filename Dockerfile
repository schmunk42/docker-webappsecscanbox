############################################
## Docker build file creating a image of a 
## box containing web application scanners
#         https://www.docker.com
############################################
# Script use following best practices 
# https://docs.docker.com/articles/dockerfile_best-practices
# Base box on Debian Jessie OS
FROM debian:8.0
MAINTAINER Dominique Righetto <dominique.righetto@gmail.com>
# Install WGET command in order to download scanner binaries
# Install PYTHON for Wapiti
# Install build dependencies for Skipfish
RUN apt-get update && apt-get install -y build-essential libidn11-dev libssl-dev libpcre3-dev make python2.7 wget
# Define global environments variables that will be used as "constants"
ENV ARACHNI_VERSION 1.0.6-0.5.6 
ENV WAPITI_VERSION 2.3.0
ENV SKIPFISH_VERSION 2.10b
ENV LANG C.UTF-8
# Download and install ARACHNI scanner
RUN wget -nv -O /tmp/arachni.tar.gz http://downloads.arachni-scanner.com/arachni-$ARACHNI_VERSION-linux-x86_64.tar.gz \
	&& tar -C /usr/local -xf /tmp/arachni.tar.gz && mv /usr/local/arachni-$ARACHNI_VERSION /usr/local/arachni && chmod -R +x /usr/local/arachni
# Validate installation
RUN /usr/local/arachni/bin/arachni --version
# Download and install WAPITI scanner 
RUN wget -nv -O /tmp/wapiti.tar.gz http://sourceforge.net/projects/wapiti/files/wapiti/wapiti-$WAPITI_VERSION/wapiti-$WAPITI_VERSION.tar.gz/download \
	&& tar -C /usr/local -xf /tmp/wapiti.tar.gz && mv /usr/local/wapiti-$WAPITI_VERSION /usr/local/wapiti && chmod -R +x /usr/local/wapiti
# Download and install Python tools in order to install Wapiti python modules dependencies
RUN wget -nv -O /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py && python2.7 /tmp/get-pip.py \
	&& pip install requests BeautifulSoup
# Validate installation (set LANG env var before to use python command)
RUN python2.7 /usr/local/wapiti/bin/wapiti --help
# Download and install SKIPFISH scanner
RUN wget -nv -O /tmp/skipfish.tgz https://skipfish.googlecode.com/files/skipfish-$SKIPFISH_VERSION.tgz \
	&& tar -C /usr/local -xf /tmp/skipfish.tgz && mv /usr/local/skipfish-$SKIPFISH_VERSION /usr/local/skipfish \
	&& cd /usr/local/skipfish && make \
	&& chmod -R +x /usr/local/skipfish && cp /usr/local/skipfish/dictionaries/minimal.wl /usr/local/skipfish/skipfish.wl
# Validate installation (add head chained command because skipfish don't have a help/version switch)
RUN /usr/local/skipfish/skipfish -h | head -1