#!/usr/bin/env bash
## Mode pas a pas
##set -x
##trap read debug
##

## DOCKER INSTALLED?
if [ -z `whoami | grep root` ]
then
	echo "YOU MUST BE ROOT TO DO THAT"
	exit
fi
if [ -z `which rpm` ]
then
	InstalledDocker=`dpkg -l | grep docker`
else
	InstalledDocker=`rpm -qa | grep docker`
fi
if [ -z "$InstalledDocker" ]
then
	if [ -z `which rpm` ]
	then 
        	if [ -z `which curl` ]; then `apt-get install -y curl`; fi
	else
        	if [ -z `which curl` ]; then `yum install -y curl`; fi
	fi
	echo "Docker not installed, Installing docker"
        curl -sSL https://get.docker.com/ | sh
##else
##	echo $InstalledDocker
fi
RsatImages=`docker images | grep rsat`
NbRsatImages=`ls -l | grep rsat_ | wc -l`
##AT LEAST ONE RSAT IMAGE?
## LOAD FROM FILE A NEWER RSAT IMAGE IF ANY, NEWER THAN ALL EXISTING LOADED IMAGES
if [ -z "$RsatImages" ]
then
	echo "No Rsat Docker image Installed; Trying to install one"
	ExistingImage=`ls | grep rsat`
	if [ -z "$ExistingImage" ]
	then
		echo "No Rsat Image here; Nothing to do"
		exit
	else
		if [ $NbRsatImages -gt 1  ]
		then
			echo "Many rsat images files; keep just one"
			exit
		fi
		RsatImage=`ls | grep rsat_`
		echo "Loading " $RsatImage
		docker load -i $RsatImage
	fi
else
	RsatLastImage=`docker images --all | grep rsat_ | sort -n -r +20 -40 | head -1 | cut -b"1-40" |  sed 's/\ /\:/' |  sed 's/\ //g'`
	if [ $NbRsatImages -eq 1  ]
	then
		 RsatImage=` ls | grep rsat_ | sed 's/.tar//g' | sed 's/-/:/'`
	fi
	if [[ "$RsatLastImage" < "$RsatImage" ]]
	then
		RsatImage=`ls | grep rsat_`
		echo "Loading " $RsatImage
		docker load -i $RsatImage
	fi 
fi
echo "You can start this program by typing  ./"`basename "$0"`
echo "You can add optionals parameters typing ./"`basename "$0"` " port directory memory version" 
echo "Default values : Default port 32801, default directory /rsat_data default memory 1g LatestVersion"
echo "Typing ./"`basename "$0"` " means ./"`basename "$0"` " 32801 /rsat_data 1g LatestVersion"
echo " " 
NbInstalledRsatImages=`docker images --all | grep rsat_ | sed 's/\ /\|/' | cut -d'|' -f1 | wc -l`
if [ -z ${4+x} ]
then 
	if [ $NbInstalledRsatImages -gt 1  ]
	then
		echo "Many rsat images loaded; latest will be used"
	fi
	RsatImage=`docker images --all | grep rsat_ | sort -n -r +20 -40 | head -1 | cut -b"1-40" |  sed 's/\ /\:/' |  sed 's/\ //g'`
else 
	RsatChosenImage=$4 
	if [ -z `echo $RsatChosenImage | grep :` ]; then RsatChosenImage=":"$RsatChosenImage; fi
	if [ -z `echo $RsatChosenImage | grep rsat_debian` ]; then RsatChosenImage="rsat_debian"$RsatChosenImage; fi
	RsatChosenImage=`echo $RsatChosenImage |  sed 's/\./-/g'`
	RsatImage=$RsatChosenImage
fi
echo " "
echo "Rsat image " $RsatImage " will be used"
if [ -z ${1+x} ]; then port=32801; else port=$1; fi
if [ $port -lt 30000 ]
then
	echo "You have choosed port " $port "Please use a port above 30000"
	exit
fi
echo "You can connect the Rsat Server using your browser at the url http://"`ifconfig eth0 | awk '/inet adr:/{print $2}' | awk -F ':' '{print $2}'`":"$port"/rsat"
if [ -z ${2+x} ]; then MountedDirectory=/rsat_data; else MountedDirectory=$2; fi
if [ -d "$MountedDirectory" ]
then
	echo " "
else
	echo "The directory " $MountedDirectory " does not exist; please give absolute path beginning with /"
	exit
fi
if [ -z ${3+x} ]; then Memory=1g; else Memory=$3; fi
echo "Type exit in this window when you finished to use this rsat web server"
echo " "
docker run -t -i -m $Memory  -v $MountedDirectory:/rsat_data -p $port:80 $RsatImage


