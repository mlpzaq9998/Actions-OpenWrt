# Copyright (C) 2020 Hyy2001X <https://github.com/Hyy2001X>

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI Support for Openwrt-AutoUpdate
LUCI_DEPENDS:=+curl +wget
LUCI_PKGARCH:=all
PKG_VERSION:=6
PKG_RELEASE:=20201009

include $(TOPDIR)/feeds/luci/luci.mk

$(eval $(call BuildPackage,luci-app-autoupdate))
