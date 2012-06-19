#/bin/bash
# 
# Setup script for Rackspace Cloud dev server
#
# Usage: bootstrap.sh <GIT_REPO>

GIT_REPO=$1

#apt-get --assume-yes update

# Install these:
# git
# unzip
# Scala
# Jetty
# Solr	
# Java JDK (default)
apt-get --assume-yes install \
	git \
	unzip \
	scala \
	jetty \
	solr-jetty \
	default-jdk

# Install Play! 2.0 Framework (from http://www.playframework.org/documentation/2.0/Installing)
curl -O http://download.playframework.org/releases/play-2.0.zip
unzip play-2.0.zip
export PATH=$PATH:~/play-2.0/

# git clone the source code
git clone $GIT_REPO

# TODO: Put data in Solr database

# Start Solr
service jetty start

# Start Play
play
