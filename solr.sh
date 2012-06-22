# Config for Solr server
apt-get --assume-yes install solr-jetty default-jdk

# TODO: Index all documents in Solr

# Start Solr
service jetty start
