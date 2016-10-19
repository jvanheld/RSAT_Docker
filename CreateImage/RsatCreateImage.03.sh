#!/usr/bin/env bash
## Mode pas a pas
set -x
trap read debug
##
## Hypotheses :
## H1 : rsat en version tar gz est dans  http://pedagogix-tagc.univ-mrs.fr/download_rsat/rsat_2016-05-24.tar.gz
## H2 : Licence vmatch est dans /rsat/vmatch_RSATVM-IFB_2015-07-06.lic 
##    : vmatch from =ftp://lscsa.de/pub/lscsa/ vmatch-2.2.5-Linux_x86_64-64bit
## H3 : blats version -2.4.0+-x64-linux est dans ftp://ftp.ncbi.nlm.nih.gov/blast/executables/LATEST/ncbi-blast-2.4.0+-x64-linux.tar.gz
## H4 : seqlogo from http://weblogo.berkeley.edu/release/weblogo.2.8.2.tar.gz
## H5 : weblogo from https://weblogo.googlecode.com/files/weblogo-3.3.tar.gz
## H6 : gjostscript from http://downloads.ghostscript.com/public/binaries/gs-9.07-linux-x86_64.tgz
## H7 : gnuplot from http://sourceforge.net/projects/gnuplot/files/gnuplot/5.0.0/gnuplot-5.0.0.tar.gz
## H8 : bedtools from =https://github.com/arq5x/bedtools2/releases/download/2.25.0/bedtools-2.25.0.tar.gz
## H9 : mcl from http://www.micans.org/mcl/src/mcl-14-137.tar.gz
## H10: rnsc from http://www.cs.utoronto.ca/~juris/data/rnsc/rnsc.tar.gz
## H11: bioperl version 1-2-3
## H12: Time Paris europe
## Update et upgarde
apt-get update
apt-get -y upgrade
apt install  -y openssh-client
##
## Time setup
echo Europe/Paris > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata
##
## Install debian packages
apt install -y git cvs r-base-core net-tools python python-numpy libssl-dev libexpat1-dev libxml2-dev apache2 apt-utils libapache2-mod-perl2 libapache2-mod-perl2-dev php5 perl-doc libdb5.3-dev cpanminus wget sudo
##
## Install perl modules
cpanm --force Net::SSLeay
##cpanm --force Net::SMTPSXML::Compile::SOAP11 --> could not find
cpanm --force Email::Sender::Transport::SMTPS
cpanm --force XML::Parser::Expat
cpanm --force SOAP::WSDL
cpanm --force XML::LibXML
cpanm --force XML::LibXML::Simple
cpanm --force XML::Compile
cpanm --force XML::Compile::Cache
cpanm --force XML::Compile::SOAP11
cpanm --force XML::Compile::WSDL11
cpanm --force YAML
cpanm --force Module::Build::Compat
cpanm --force CGI
cpanm --force Email::Sender
cpanm --force Email::Simple
cpanm --force Email::Simple::Creator
cpanm --force PostScript::Simple
cpanm --force Statistics::Distributions
cpanm --force Math::CDF
cpanm --force Algorithm::Cluster
cpanm --force File::Spec
cpanm --force POSIX
cpanm --force Data::Dumper
cpanm --force Digest::MD5::File
cpanm --force IO::All
cpanm --force LockFile::Simple
cpanm --force Object::InsideOut
cpanm --force Util::Properties
cpanm --force Class::Std::Fast
cpanm --force GD
cpanm --force DBI
cpanm --force DBD::mysql
cpanm --force DB_File
cpanm --force LWP::Simple
cpanm --force REST::Client
cpanm --force JSON
cpanm --force HTTP::Tiny
cpanm --force XML::Compile::Transport::SOAPHTTP
cpanm --force SOAP::Lite
cpanm --force SOAP::Packager
cpanm --force SOAP::Transport::HTTP
cpanm --force SOAP::WSDL
cpanm --force Bio::Perl
cpanm --force Bio::Das
cpanm --force XML::DOM
cpanm --force Spreadsheet::WriteExcel::Big
cpanm --force Spreadsheet::WriteExcel
cpanm --force Log::Log4perl
cpanm --force Number::Format
cpanm --force OLE::Storage_Lite
cpanm --force Template::Plugin::Number::Format
cpanm --force Readonly
##
## Validate perl cgi et php under apache2
a2enmod cgi
a2enmod perl
a2enmod php5
##
## get and install rsat tar.gz dans /rsat
cd /
wget http://pedagogix-tagc.univ-mrs.fr/download_rsat/rsat_2016-05-24.tar.gz
mv rsat_2016-05-24.tar.gz rsat.tar.gz
gunzip rsat.tar.gz
tar -xvf rsat.tar
##
##
## Configuration rsat install dans /rsat
## *************************************
## On ne va pas jour le scriptperl perl-scripts/configure_rsat.pl on modifie les ficheirs directement
## Trois fichiers concernes :
##  RSAT_config.props
##    config file read by RSAT programs in various languages: Perl,
##    python, java
## cp  RSAT_config_default.props  RSAT_config.props
##
## RSAT_config.mk
##    environment variables for the makefiles
##cp RSAT_config_default.mk RSAT_config.mk
##
## RSAT_config.conf
##    RSAT configuration for the Apache web server.
## cp  RSAT_config_default.conf  RSAT_config.conf
## mise a jour RSAT_config.bashrc
## path /rsat
##
## Mise a jour fichier RSAT_config.bashrc a partir de RSAT_config_default.bashrc
cd /rsat
sed 's/\[RSAT_PARENT_PATH\]//g' ./RSAT_config_default.bashrc > ./RSAT_config.bashrc
echo -e "export RSAT_PARENT_PATH=\n$(cat  RSAT_config.bashrc)" > RSAT_config.bashrc
source RSAT_config.bashrc
echo "source /rsat/RSAT_config.bashrc" >>  /etc/bash.bashrc
echo "service apache2 start" >>  /etc/bash.bashrc 
##
## Mise a jour RSAT_config.props
i=`ifconfig eth0 | awk '/inet adr:/{print $2}' | awk -F ':' '{print $2}'` | sed -e "s/your_server_name/$i/g"  ./RSAT_config_default.props | sed 's/your.mail@your.mail.server/postmaster@rsat.com/g' | sed 's/\[RSAT_PARENT_PATH\]//g' > ./RSAT_config.props
##
## Mise a jour RSAT_config.mk apt-get pour debian
## RSAT_config.mk apt-get
i=`ifconfig eth0 | awk '/inet adr:/{print $2}' | awk -F ':' '{print $2}'` | sed -e "s/your_server_name/$i/g"  ./RSAT_config_default.mk | sed 's/your.mail@your.mail.server/postmaster@rsat.com/g' | sed 's/\[RSAT_PARENT_PATH\]//g' | sed 's/SUDO=/SUDO=sudo/g' > ./RSAT_config.mk
## 
## Mise a jour RSAT_config.mk YUM pour REDHAT
## RSAT_config.mk yum
## i=`ifconfig eth0 | awk '/inet adr:/{print $2}' | awk -F ':' '{print $2}'` | sed -e "s/your_server_name/$i/g"  ./RSAT_config_default.mk | sed 's/your.mail@your.mail.server/postmaster@rsat.com/g' | sed 's/\[RSAT_PARENT_PATH\]//g' | sed 's/SUDO=/SUDO=sudo/g' | sed 's/apt-get/yum/g' > ./RSAT_config.mk
##
## Make directories
mkdir /rsat/public_html/logs
make -f makefiles/init_rsat.mk init
## 
## Compile
make -f makefiles/init_rsat.mk compile_all
## 
##vmatch licence qui est dans /somewhere/vmatch_RSATVM-IFB_2015-07-06.lic
mv /RsatInstall/vmatch_RSATVM-IFB_2015-07-06.lic /rsat/bin/vmatch.lic
##
## Install thrid party
## Probleme install blast et version de vmatch (2.2.4-->2.2.5)
mv makefiles/install_software.mk makefiles/install_software_default.mk
sed -e 's/install_blast//g' makefiles/install_software_default.mk | sed -e 's/2.2.4/2.2.5/g' > makefiles/install_software.mk
make -f makefiles/install_software.mk install_ext_apps
##
## Install blast
cd /rsat/bin
wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/LATEST/ncbi-blast-2.4.0+-x64-linux.tar.gz
gunzip ncbi-blast-2.4.0+-x64-linux.tar.gz
tar -xvf ncbi-blast-2.4.0+-x64-linux.tar
mv ncbi-blast-2.4.0+/bin/* .
rm ncbi-blast-2.4.0+-x64-linux.tar
rm -rf ncbi-blast-2.4.0+-
cd /rsat
## 
## Install organismes
download-organism -v 1 -org Saccharomyces_cerevisiae
download-organism -v 1 -org Escherichia_coli_K_12_substr__MG1655_uid57779
##
## Modifier config apache
## Modele dans  /rsat/RSAT_config_default.conf
sed -e 's/\[RSAT_PARENT_PATH\]//g' RSAT_config_default.conf > /etc/apache2/sites-enabled/rsat.conf
##
## Modifier config apache2 generale pour execution perl 
## fichiers concernes /etc/apache2/apache2.conf RSAT_config_default.conf (/etc/apache2/sites-enabled/rsat.conf) 
echo 'AddHandler cgi-script .cgi .pl' >> /etc/apache2/apache2.conf
##
## redemarrer apache2 
service apache2 restart

