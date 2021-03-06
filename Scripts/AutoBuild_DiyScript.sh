#!/bin/bash
# https://github.com/Hyy2001X/AutoBuild-Actions
# AutoBuild Module by Hyy2001
# AutoBuild DiyScript

Diy_Core() {
	Author=ZYL
	Default_Device=x86_64
	Short_Firmware_Date=true
	Default_IP_Address=192.168.3.1

	INCLUDE_AutoUpdate=true
	INCLUDE_AutoBuild_Tools=true
	INCLUDE_DRM_I915=true
	INCLUDE_Theme_Argon=true
	INCLUDE_Obsolete_PKG_Compatible=false

	Upload_VM_Firmware=false
}

Firmware-Diy() {
	TIME "Starting run Firmware-Diy commands..."
	AddPackage git other luci-app-adguardhome Hyy2001X

	case ${TARGET_PROFILE} in
	d-team_newifi-d2)
		Replace_File CustomFiles/mac80211.sh package/kernel/mac80211/files/lib/wifi
		Replace_File CustomFiles/system_d-team_newifi-d2 package/base-files/files/etc/config system
		# Replace_File CustomFiles/Patches/102-mt7621-fix-cpu-clk-add-clkdev.patch target/linux/ramips/patches-5.4
	;;
	esac
	
	rm -rf ./package/lean/luci-app-wrtbwmon

	cp -r -f $GITHUB_WORKSPACE/CustomFiles/luci-app-cupsd ./package/lean/luci-app-cupsd
	cp -r -f $GITHUB_WORKSPACE/CustomFiles/cups ./package/lean/cups
	cp -r -f $GITHUB_WORKSPACE/CustomFiles/cups-bjnp ./package/lean/cups-bjnp
	cp -r -f $GITHUB_WORKSPACE/CustomFiles/luci-app-dockerman ./package/lean/luci-app-dockerman
	cp -r -f $GITHUB_WORKSPACE/CustomFiles/luci-app-wrtbwmon ./package/lean/luci-app-wrtbwmon
	cp -r -f $GITHUB_WORKSPACE/CustomFiles/wrtbwmon ./package/lean/wrtbwmon
	cp -r -f $GITHUB_WORKSPACE/CustomFiles/luci-app-koolproxyR ./package/lean/luci-app-koolproxyR
	cp -r -f $GITHUB_WORKSPACE/CustomFiles/koolproxy ./package/lean/koolproxy
	chmod -R 755 ./package/lean/luci-app-koolproxyR
	chmod -R 755 ./package/lean/koolproxy
	chmod -R 755 ./package/lean/luci-app-dockerman
	chmod -R 755 ./package/lean/luci-app-cupsd
	chmod -R 755 ./package/lean/cups
	chmod -R 755 ./package/lean/cups-bjnp
}
