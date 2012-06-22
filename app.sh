#/bin/bash
# 
# Setup script for App server
#
# Usage: app.sh

PLAY_DIR=~/play-2.0/

# if [ -z $1 ]; then
# 	echo "Usage: app.sh"
# 	echo
# 	exit;
# fi

cd ~

#apt-get --assume-yes update

#
# Put database documents in place
#
for REPO in \
	https://github.com/troyh/beercrush_web.git \
	https://github.com/troyh/beerdata.git \
; do 
	DIR=$(basename $REPO .git)
	if [ ! -d ~/$DIR ]; then
		git clone $REPO ~/$DIR
	fi
done

#
# Install Play! 2.0 Framework (from http://www.playframework.org/documentation/2.0/Installing)
#
apt-get --assume-yes install unzip scala

if [ ! -d $PLAY_DIR ]; then
	if [ ! -f play-2.0.zip ]; then
		curl -O http://download.playframework.org/releases/play-2.0.zip
	fi
	unzip play-2.0.zip
fi
export PATH=$PATH:$PLAY_DIR

#
# Start Play
#
# echo PATH=$PATH
cd ~/beercrush_web
$PLAY_DIR/play
