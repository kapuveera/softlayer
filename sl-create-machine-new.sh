#!/bin/bash
#
# Created:	20-April-2015
# Author:	EJK
# Description:
# A short script to help with creating SoftLayer virtual machines
# from the command line. This basic script will help developers or 
# other users unfamiliar with the SoftLayer-CLI to instance machines
# safely and quickly. This script doesn't cover all aspects of machine 
# creation on SoftLayer - rather I've chosen my most common build 
# requirements. It can be expanded easily to add the other options i.e.
# network, larger cpu's etc.
#
# Dependencies:
# 1) Installed SoftLayer CLI with pip
# 2) Set up your API keys for access to SoftLayer
#
# License: MIT
# Copyright (c) 2015 Eamonn Killian, www.eamonnkillian.com
#
# Permission is hereby granted, free of charge, to any person obtaining a copy 
# of this software and associated documentation files (the "Software"), to deal 
# in the Software without restriction, including without limitation the rights 
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
# copies of the Software, and to permit persons to whom the Software is furnished 
# to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all 
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
# PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# Set up our global variables 
#

SMALLCPU=1
SMALLMEM=1024
MEDCPU=1
MEDMEM=2048
LRGCPU=1
LRGMEM=4096

#
# Any functions we're defining - POSIX Standard
#

to_Confirm () {
        while [ -z $CONFIRM ]
        do
                read -p "Confirm you want to create this machine (Y/n): " CONFIRM
        done

	case $CONFIRM in
		y|Y) echo " "
		echo "Sending Command Now"
		$ARG
		echo " "
		;;
		*) echo " "
		echo "Aborting..."
		echo " "
		;;
	esac
}


#
# Lets get to the main thrust of this
#

echo "-------------------------------------------"
echo "Creating a new Virtual Machine on SoftLayer"
echo "-------------------------------------------"

#
# Get the hostname 
# 

while [ -z $MYHOST ]
	do
		read -p "Enter a name for your new host: " MYHOST
	done

#
# Get the domainname
#

while [ -z $DOMNAME ]
        do
                read -p "Enter a domainname for your new host: " DOMNAME
        done

#
# Find out whether its hourly or monthly 
#


echo " "
echo "What size of machine do you want to create? "
echo "--------------------------------------------------"
echo "| Choices:                                       |"
echo "| 1) Hourly                                      |"
echo "| 2) Monthly                                     |"
echo "| Enter 1 or 2                                   |"
echo "--------------------------------------------------"
echo " "

while [ -z $TIMING ]
        do
                read -p "Choose hourly or monthly: " TIMING
        done

#
# Checking our choice is between 1 and 2 
#

while [ $TIMING != 1 ] && [ $TIMING != 2 ] || [ -z $TIMING ]
        do
                read -p "You must choose a size between 1 and 2:" TIMING
        done

case $TIMING in
	1) TIMEVALUE=hourly
	;;
	2) TIMEVALUE=monthly
	;;
esac

#
# Get the size of our machine from a restrictive list
# Feel free to add more choices ...
#

echo " "
echo "What size of machine do you want to create? "
echo "--------------------------------------------------"
echo "| Choices:                                       |"
echo "| 1) Small = 1 processor; 1GB memory; 25GB disk  |"
echo "| 2) Medium = 1 processor; 2GB memory; 25GB disk |"
echo "| 3) Large = 2 processors; 4GB memory; 25GB disk |"
echo "| Enter 1, 2 or 3                                |"
echo "--------------------------------------------------"
echo " "

while [ -z $SIZE ] 
	do
		read -p "Choose a size: " SIZE
	done

#
# Checking our choice is between 1 and 3
#

while [ $SIZE != 1 ] && [ $SIZE != 2 ] && [ $SIZE != 3 ] || [ -z $SIZE ]
	do
		read -p "You must choose a size between 1 and 3:" SIZE
	done

#
# Get the operating systems of our machine from a restrictive list
# Feel free to add more choices ...
#

echo " "
echo "What operating system do you want to create? "
echo "--------------------------------------------------"
echo "| Choices:                                       |"
echo "| 1) CentOS 6 64-bit                             |"
echo "| 2) CentOS 7 64-bit                             |"
echo "| 3) Ubuntu 12 64-bit                            |"
echo "| 4) Ubuntu 14 64-bit                            |"
echo "| 5) RedHat 6 64-bit                             |"
echo "| 6) RedHat 7 64-bit                             |"
echo "| Enter a number between 1 and 6                 |"
echo "--------------------------------------------------"
echo " "

while [ -z $OS ]
        do
                read -p "Choose an operating system: " OS
        done

#
# Checking our choice is between 1 and 6 
#

while [ $OS != 1 ] && [ $OS != 2 ] && [ $OS != 3 ] && [ $OS != 4 ] && [ $OS != 5 ] && [ $OS != 6 ] || [ -z $OS ]
        do
                read -p "You must choose between 1 and 6:" OS
        done

case $OS in
	1) OSNAME=CENTOS_6_64
	;;
        2) OSNAME=CENTOS_7_64
        ;;
        3) OSNAME=UBUNTU_12_64
        ;;
        4) OSNAME=UBUNTU_14_64
        ;;
        5) OSNAME=REDHAT_6_64
        ;;
        6) OSNAME=REDHAT_6_64
        ;;
esac

#
# Lets get the datacenter you want to put this virtual machine into
#

echo " "
echo "What datacenter do you want to use? "
echo "--------------------------------------------------"
echo "| Choices:                                       |"
echo "| 1) London                                      |"
echo "| 2) Paris                                       |"
echo "| 3) Amsterdam - Pod3                            |"
echo "| 4) Milan                                       |"
echo "| 5) Frankfurt                                   |"
echo "| Enter a number between 1 and 5                 |"
echo "--------------------------------------------------"
echo " "

while [ -z $DC ]
        do
                read -p "Choose a data center: " DC
        done

#
# Checking our choice is between 1 and 5 
#

while [ $DC != 1 ] && [ $DC != 2 ] && [ $DC != 3 ] && [ $DC != 4 ] && [ $DC != 5 ] || [ -z $DC ]
        do
                read -p "You must choose between 1 and 5:" DC
        done

case $DC in
        1) DCNAME=lon02
        ;;
        2) DCNAME=par01
        ;;
        3) DCNAME=ams03
        ;;
        4) DCNAME=mil01
        ;;
        5) DCNAME=fra02
        ;;
esac

#
# Run the SoftLayer CLI create command
# 

case $SIZE in
	1) echo " "
	echo "------------------------------------------------------------------------------------------------------"
	echo " "
	echo "Creating $MYHOST - as a small `exec echo $OSNAME | cut -d "_" -f1 | awk '{print tolower($0)}'` Machine"
	echo " "
	ARG="slcli vs create --hostname $MYHOST --domain $DOMNAME -c $SMALLCPU -m $SMALLMEM -o $OSNAME --billing $TIMEVALUE --datacenter $DCNAME"
	to_Confirm
	echo " "
	echo "------------------------------------------------------------------------------------------------------" 
	echo " "
	;;
	2) echo " "
	echo "------------------------------------------------------------------------------------------------------"
        echo " "
	echo "Creating $MYHOST - as a medium `exec echo $OSNAME | cut -d "_" -f1 | awk '{print tolower($0)}'` Machine"
	ARG="slcli vs create --hostname $MYHOST --domain $DOMNAME -c $MEDCPU -m $MEDMEM -o $OSNAME --billing $TIMEVALUE --datacenter $DCNAME"
	to_Confirm 
	echo " "
	echo "------------------------------------------------------------------------------------------------------"
        echo " "
	;;
	3) echo " "
	echo "------------------------------------------------------------------------------------------------------"
        echo " "
	echo "Creating $MYHOST - as a large `exec echo $OSNAME | cut -d "_" -f1 | awk '{print tolower($0)}'` Machine"
	ARG="slcli vs create --hostname $MYHOST --domain $DOMNAME -c $LRGCPU -m LRGMEM -o $OSNAME --billing $TIMEVALUE --datacenter $DCNAME"
	to_Confirm
	echo " "
	echo "------------------------------------------------------------------------------------------------------"
        echo " "
	;;
esac

