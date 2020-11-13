#!/bin/sh
# https://github.com/Hyy2001X/AutoBuild-Actions
# AutoBuild Module by Hyy2001

[ -f /tmp/cloud_version ] && rm -f /tmp/cloud_version
if [ ! -f /bin/AutoUpdate.sh ];then
	echo "不受支持的固件" > /tmp/cloud_version
	exit
fi
Github=`awk -F '[=]' '/Github/{print $2}' /bin/AutoUpdate.sh | awk 'NR==1'`
[[ -z "$Github" ]] && exit
Author=${Github##*com/}
Github_Tags=https://api.github.com/repos/$Author/releases/latest
GET_Version=`wget -q $Github_Tags -O - | egrep -o 'R[0-9]+.[0-9]+.[0-9]+.[0-9]+' | awk 'END {print}'`
CURRENT_Version=$(awk 'NR==1' /etc/openwrt_info)
if [[ -z "$GET_Version" ]];then
	echo "未知" > /tmp/cloud_version
	exit
else
	if [[ "$CURRENT_Version" == "$GET_Version" ]];then
		echo "$GET_Version [最新]" > /tmp/cloud_version
	else
		echo "$GET_Version [可更新]" > /tmp/cloud_version
	fi
fi
exit
