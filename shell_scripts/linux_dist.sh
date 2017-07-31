#!/bin/bash
found=0;
if [ -e /etc/SuSE-release ]; then echo "You have a SUSE distro"; found=1; fi
if [ -e /etc/redhat-release ]; then echo "You have a Red Hat distro"; found=1; fi
if [ -e /etc/fedora-release ]; then echo "You have a Fedora distro"; found=1; fi
if [ -e /etc/debian-version ]; then echo "You have a Debian, Ubuntu, Kubuntu, Edubuntu or Flubuntu distro"; found=1; fi
if [ -e /etc/slackware-version ]; then echo "You have a SlackWare distro"; found=1; fi
if ! [ $found = 1 ]; then echo "I could not find out your distro"; fi

