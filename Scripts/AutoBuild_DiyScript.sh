#!/bin/bash
# https://github.com/Hyy2001X/AutoBuild-Actions
# AutoBuild Module by Hyy2001
# AutoBuild DiyScript

Diy_Core() {
	Author=ZYL
	Default_Device=x86_64

	INCLUDE_AutoUpdate=true
	INCLUDE_AutoBuild_Tools=true
	INCLUDE_Keep_Latest_Xray=true
	INCLUDE_mt7621_OC1000MHz=true
	INCLUDE_Enable_FirewallPort_53=true

	INCLUDE_SSR_Plus=true
	INCLUDE_Passwall=true
	INCLUDE_HelloWorld=false
	INCLUDE_Bypass=false
	INCLUDE_OpenClash=false
}

Diy-Part1() {
	Diy_Part1_Base
	
	Replace_File Customize/mac80211.sh package/kernel/mac80211/files/lib/wifi
	if [ "${Default_Device}" == "d-team_newifi-d2" ];then
		Replace_File Customize/system_newifi-d2 package/base-files/files/etc/config system
	else
		Replace_File Customize/system_common package/base-files/files/etc/config system
	fi
	Replace_File Customize/banner package/base-files/files/etc
	
	Update_Makefile exfat package/kernel/exfat

	Replace_File Customize/mt76-20210127.mk package/kernel/mt76 Makefile
	rm -rf package/kernel/mt76/patches

	# ExtraPackages svn network/services dnsmasq https://github.com/openwrt/openwrt/trunk/package/network/services
	# ExtraPackages svn network/services dropbear https://github.com/openwrt/openwrt/trunk/package/network/services
	# ExtraPackages svn network/services ppp https://github.com/openwrt/openwrt/trunk/package/network/services
	# ExtraPackages svn network/services hostapd https://github.com/openwrt/openwrt/trunk/package/network/services
	# ExtraPackages svn kernel mt76 https://github.com/openwrt/openwrt/trunk/package/kernel
	
	rm -rf package/lean/luci-theme-argon
	rm -rf package/lean/luci-app-wrtbwmon
	ExtraPackages git lean luci-theme-argon https://github.com/jerrykuku 18.06
	ExtraPackages git other luci-app-argon-config https://github.com/jerrykuku master
	ExtraPackages git other luci-app-adguardhome https://github.com/Hyy2001X master
	ExtraPackages git other luci-app-shutdown https://github.com/Hyy2001X master
	ExtraPackages svn other luci-app-smartdns https://github.com/project-openwrt/openwrt/trunk/package/ntlf9t
	ExtraPackages git other luci-app-serverchan https://github.com/tty228 master
	ExtraPackages svn other luci-app-socat https://github.com/Lienol/openwrt-package/trunk
	ExtraPackages svn other luci-app-usb3disable https://github.com/project-openwrt/openwrt/trunk/package/ctcgfw
	ExtraPackages svn other luci-app-eqos https://github.com/garypang13/luci-app-eqos
	Replace_File Customize/luci-app-wrtbwmon package/lean/luci-app-wrtbwmon
	Replace_File Customize/wrtbwmon package/lean/wrtbwmon
	Replace_File Customize/luci-app-koolproxyR package/lean/luci-app-koolproxyR
	Replace_File Customize/koolproxy package/lean/koolproxy
	mv package/lean/luci-app-eqos/po/zh_Hans package/lean/luci-app-eqos/po/zh-cn
	echo CONFIG_BINFMT_MISC=y >> target/linux/x86/config-5.4

}

Diy-Part2() {
	Diy_Part2_Base
	# Modify default IP
	sed -i 's/192.168.1.1/192.168.3.1/g' package/base-files/files/bin/config_generate
	sed -i 's/bootstrap/argon/g' feeds/luci/modules/luci-base/root/etc/config/luci

	# ExtraPackages svn feeds/packages mwan3 https://github.com/openwrt/packages/trunk/net
}

Diy-Part3() {
	Diy_Part3_Base
}
