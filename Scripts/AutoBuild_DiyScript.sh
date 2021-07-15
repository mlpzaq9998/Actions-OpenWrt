#!/bin/bash
# AutoBuild Module by Hyy2001 <https://github.com/Hyy2001X/AutoBuild-Actions>
# AutoBuild DiyScript

Diy_Core() {
	Author=Hyy2001
	Short_Firmware_Date=true
	Default_LAN_IP=false

	INCLUDE_AutoBuild_Features=true
	INCLUDE_DRM_I915=true
	INCLUDE_Argon=true
	INCLUDE_Obsolete_PKG_Compatible=false
}

Firmware-Diy() {
	case "${TARGET_PROFILE}" in
	d-team_newifi-d2)
		Copy CustomFiles/mac80211.sh package/kernel/mac80211/files/lib/wifi
		Copy CustomFiles/system_${TARGET_PROFILE} package/base-files/files/etc/config system
	;;
	*)
		:
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