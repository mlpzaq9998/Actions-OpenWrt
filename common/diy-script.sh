#!/bin/bash
# https://github.com/Hyy2001X/AutoBuild-Actions
# AutoBuild Module by Hyy2001
# AutoBuild Actions

Diy_Core() {
Author=ZYL

Default_File=./package/base-files/files/etc/openwrt_release
Lede_Version="Master"
Openwrt_Version="$Lede_Version-`date +%Y%m%d`"
AutoUpdate_Version=`awk 'NR==6' ./package/base-files/files/bin/AutoUpdate.sh | awk -F'[="]+' '/Version/{print $2}'`
Compile_Date=`date +'%Y/%m/%d'`
Compile_Time=`date +'%Y-%m-%d %H:%M:%S'`
TARGET_PROFILE=`egrep -o "CONFIG_TARGET_.[0-9]+.[0-9]+=y" .config | sed -r 's/.*TARGET_(.*)=y/\1/'`
}

GET_TARGET_INFO() {
TARGET_BOARD=`awk -F'[="]+' '/TARGET_BOARD/{print $2}' .config`
TARGET_SUBTARGET=`awk -F'[="]+' '/TARGET_SUBTARGET/{print $2}' .config`
}

Diy-Part1() {
# Modify default IP
sed -i 's/192.168.9.1/192.168.3.1/g' ./package/base-files/files/bin/config_generate

}

Diy-Part2() {
Diy_Core
GET_TARGET_INFO
rm -rf ./package/feeds/custom/luci-app-koolproxyR
cp -r -f $GITHUB_WORKSPACE/Customize/open-vm-tools ./package/feeds/custom/open-vm-tools
cp -r -f $GITHUB_WORKSPACE/Customize/luci-app-koolproxyR ./package/feeds/custom/luci-app-koolproxyR
cp -r $GITHUB_WORKSPACE/Customize/koolproxy/files/amd64/koolproxy ./package/feeds/custom/luci-app-koolproxyR/root/usr/share/koolproxy/koolproxy
sed -i "s/ +koolproxy//g" package/feeds/custom/luci-app-koolproxyR/Makefile
chmod -R 755 ./package/feeds/custom/luci-app-koolproxyR
rm -rf ./package/feeds/custom/luci-app-gpsysupgrade
cp -r -f $GITHUB_WORKSPACE/Customize/luci-app-gpsysupgrade ./package/feeds/custom/luci-app-gpsysupgrade
cp -f $GITHUB_WORKSPACE/x86_64/sysupgrade.lua ./package/feeds/custom/luci-app-gpsysupgrade/luasrc/model/cbi/gpsysupgrade/api/sysupgrade.lua
mv ./package/feeds/custom/luci-app-gpsysupgrade/po/zh-cn ./package/feeds/custom/luci-app-gpsysupgrade/po/zh_Hans
sed -i "s/DISTRIB_DESCRIPTION.*/DISTRIB_DESCRIPTION='%D %V %C by ZYL'/g" package/base-files/files/etc/openwrt_release
cp -r -f $GITHUB_WORKSPACE/Customize/luci-app-autoupdate ./package/feeds/custom/luci-app-autoupdate
cp -f $GITHUB_WORKSPACE/x86_64/AutoUpdate.sh ./package/base-files/files/bin/AutoUpdate.sh
chmod -R 755 ./package/feeds/custom/luci-app-autoupdate/root/usr/share/autoupdate/Check_Update.sh
chmod -R 755 ./package/base-files/files/bin/AutoUpdate.sh
echo CONFIG_BINFMT_MISC=y >> ./target/linux/x86/config-5.4

echo "Author: $Author"
echo "Openwrt Version: $Openwrt_Version"
echo "AutoUpdate Version: $AutoUpdate_Version"
echo "Device: $TARGET_PROFILE"
sed -i '/DISTRIB_REVISION/d' $Default_File
echo "DISTRIB_REVISION='Master'" >> $Default_File
sed -i "s?$Lede_Version?$Lede_Version Compiled by $Author [$Compile_Date]?g" $Default_File
echo "$Openwrt_Version" > ./package/base-files/files/etc/openwrt_info
sed -i "s?Openwrt?Openwrt $Openwrt_Version / AutoUpdate $AutoUpdate_Version?g" ./package/base-files/files/etc/banner

}

Diy-Part3() {
Diy_Core
GET_TARGET_INFO
Default_Firmware_EFI=openwrt-$TARGET_BOARD-$TARGET_SUBTARGET-generic-squashfs-combined-efi.img.gz
AutoBuild_Firmware_EFI=AutoBuild-$TARGET_PROFILE-OpenWrt-${Openwrt_Version}-efi.img.gz
AutoBuild_Detail_EFI=AutoBuild-$TARGET_PROFILE-OpenWrt-${Openwrt_Version}-efi.detail
Default_Firmware=openwrt-$TARGET_BOARD-$TARGET_SUBTARGET-generic-squashfs-combined.img.gz
AutoBuild_Firmware=AutoBuild-$TARGET_PROFILE-OpenWrt-${Openwrt_Version}.img.gz
AutoBuild_Detail=AutoBuild-$TARGET_PROFILE-OpenWrt-${Openwrt_Version}.detail
Default_Firmware_vmdk=openwrt-$TARGET_BOARD-$TARGET_SUBTARGET-generic-squashfs-combined.vmdk
mkdir -p ./bin/Firmware
echo -n "$Openwrt_Version" > ./bin/Firmware/AutoBuild-$TARGET_PROFILE-OpenWrt-Master-Version.txt
echo "[$(date "+%H:%M:%S")] Moving $Default_Firmware to /bin/Firmware/$AutoBuild_Firmware ..."
mv ./bin/targets/$TARGET_BOARD/$TARGET_SUBTARGET/$Default_Firmware_EFI ./bin/Firmware/$AutoBuild_Firmware_EFI
mv ./bin/targets/$TARGET_BOARD/$TARGET_SUBTARGET/$Default_Firmware ./bin/Firmware/$AutoBuild_Firmware
echo "[$(date "+%H:%M:%S")] Calculating MD5 and SHA256 ..."
EFI_Firmware_MD5=`md5sum ./bin/Firmware/$AutoBuild_Firmware_EFI | cut -d ' ' -f1`
EFI_Firmware_SHA256=`sha256sum ./bin/Firmware/$AutoBuild_Firmware_EFI | cut -d ' ' -f1`
echo "编译日期:$Compile_Time" > ./bin/Firmware/$AutoBuild_Detail_EFI
echo -e "\nMD5:$EFI_Firmware_MD5\nSHA256:$EFI_Firmware_SHA256" >> ./bin/Firmware/$AutoBuild_Detail_EFI
Firmware_MD5=`md5sum ./bin/Firmware/$AutoBuild_Firmware | cut -d ' ' -f1`
Firmware_SHA256=`sha256sum ./bin/Firmware/$AutoBuild_Firmware | cut -d ' ' -f1`
echo "编译日期:$Compile_Time" > ./bin/Firmware/$AutoBuild_Detail
echo -e "\nMD5:$Firmware_MD5\nSHA256:$Firmware_SHA256" >> ./bin/Firmware/$AutoBuild_Detail
}
