#!/bin/sh
# https://github.com/Hyy2001X/AutoBuild-Actions
# AutoBuild Module by Hyy2001

Github=`awk -F '[=]' '/Github/{print $2}' /bin/AutoUpdate.sh | awk 'NR==1'`
Github_Tags=$Github/releases/tag/AutoUpdate
GET_Version=`wget -q $Github_Tags -O - | egrep -o 'R[0-9]+.[0-9]+.[0-9]+.[0-9]+' | awk 'END {print}'`
if [ -z "$GET_Version" ];then
	echo "未知" > /tmp/cloud_version
	exit
fi
echo "$GET_Version" > /tmp/cloud_version
