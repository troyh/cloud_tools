# Config for Solr server

cd ~

#
# Install Solr 3.6.0 (from http://www.gazoakley.com/content/installing-apache-solr-3.6-3.x-ubuntu-debian)
#
apt-get --assume-yes install default-jdk
if [ ! -f apache-solr-3.6.0.tgz ]; then
	wget http://mirrors.ibiblio.org/apache/lucene/solr/3.6.0/apache-solr-3.6.0.tgz
fi
tar -xzvf apache-solr-3.6.0.tgz
cp -Rf apache-solr-3.6.0 /usr/share/solr
if [ ! -f jetty.sh ]; then
	wget http://svn.codehaus.org/jetty/jetty/branches/jetty-6.1/bin/jetty.sh
fi
cp jetty.sh /etc/init.d/jetty
chmod 755 /etc/init.d/jetty

cat > /etc/default/jetty << EOF
JAVA_HOME=/usr/java/default
JAVA_OPTIONS="-Dsolr.solr.home=/usr/share/solr \$JAVA_OPTIONS"
JETTY_HOME=/usr/share/solr
JETTY_USER=solr
JETTY_LOGS=/var/log/solr
JAVA_HOME=/usr/lib/jvm/default-java
JDK_DIRS="/usr/lib/jvm/default-java /usr/lib/jvm/java-6-sun"
EOF

mkdir -p /var/log/solr
cat > /usr/share/jetty/etc/jetty-logging.xml <<EOF
<?xml version="1.0"?>
<!DOCTYPE Configure PUBLIC "-//Mort Bay Consulting//DTD Configure//EN" "http://jetty.mortbay.org/configure.dtd">
<!-- =============================================================== -->
<!-- Configure stderr and stdout to a Jetty rollover log file -->
<!-- this configuration file should be used in combination with -->
<!-- other configuration files. e.g. -->
<!-- java -jar start.jar etc/jetty-logging.xml etc/jetty.xml -->
<!-- =============================================================== -->
<Configure id="Server" class="org.mortbay.jetty.Server">
<New id="ServerLog" class="java.io.PrintStream">
<Arg>
<New class="org.mortbay.util.RolloverFileOutputStream">
<Arg><SystemProperty name="jetty.logs" default="."/>/yyyy_mm_dd.stderrout.log</Arg>
<Arg type="boolean">false</Arg>
<Arg type="int">90</Arg>
<Arg><Call class="java.util.TimeZone" name="getTimeZone"><Arg>GMT</Arg></Call></Arg>
<Get id="ServerLogName" name="datedFilename"/>
</New>
</Arg>
</New>
<Call class="org.mortbay.log.Log" name="info"><Arg>Redirecting stderr/stdout to <Ref id="ServerLogName"/></Arg></Call>
<Call class="java.lang.System" name="setErr"><Arg><Ref id="ServerLog"/></Arg></Call>
<Call class="java.lang.System" name="setOut"><Arg><Ref id="ServerLog"/></Arg></Call>
</Configure>
EOF

useradd -d /usr/share/solr -s /bin/false solr
chown solr:solr -R /usr/share/solr
chown solr:solr -R /var/log/solr

#
# Use our schema
#
cp ~/cloud_tools/schema.xml /usr/share/solr/conf/schema.xml

# TODO: Index all documents in Solr

#
# Start Solr
#
service jetty start
