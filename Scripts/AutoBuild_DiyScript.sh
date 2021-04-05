#!/bin/bash
# https://github.com/Hyy2001X/AutoBuild-Actions
# AutoBuild Module by Hyy2001
# AutoBuild DiyScript

Diy_Core() {
	Author=ZYL
	Default_Device=x86_64

	INCLUDE_AutoUpdate=true
	INCLUDE_AutoBuild_Tools=true
	INCLUDE_DRM_I915=true
	INCLUDE_Translation_Converter=
}

Firmware-Diy() {
	Update_Makefile exfat package/kernel/exfat
	Replace_File CustomFiles/webadmin.po package/lean/luci-app-webadmin/po/zh-cn
	
	case ${TARGET_PROFILE} in
	d-team_newifi-d2)
		Replace_File CustomFiles/mac80211.sh package/kernel/mac80211/files/lib/wifi
		Replace_File CustomFiles/system_newifi-d2 package/base-files/files/etc/config system
		Replace_File CustomFiles/102-mt7621-fix-cpu-clk-add-clkdev.patch target/linux/ramips/patches-5.4
	;;
	*)
		Replace_File CustomFiles/system_common package/base-files/files/etc/config system
	;;
	esac		
		
	rm -rf package/lean/luci-app-wrtbwmon

	cp -r -f $GITHUB_WORKSPACE/CustomFiles/luci-app-dockerman ./package/lean/luci-app-dockerman
	cp -r -f $GITHUB_WORKSPACE/CustomFiles/luci-app-wrtbwmon ./package/lean/luci-app-wrtbwmon
	cp -r -f $GITHUB_WORKSPACE/CustomFiles/wrtbwmon ./package/lean/wrtbwmon
	cp -r -f $GITHUB_WORKSPACE/CustomFiles/luci-app-koolproxyR ./package/lean/luci-app-koolproxyR
	cp -r -f $GITHUB_WORKSPACE/CustomFiles/koolproxy ./package/lean/koolproxy
	chmod -R 755 ./package/lean/luci-app-koolproxyR
	chmod -R 755 ./package/lean/koolproxy
	chmod -R 755 ./package/lean/luci-app-dockerman
	
	sed -i 's/192.168.1.1/192.168.3.1/g' package/base-files/files/bin/config_generate
	sed -i 's/bootstrap/argon/g' feeds/luci/modules/luci-base/root/etc/config/luci
}

