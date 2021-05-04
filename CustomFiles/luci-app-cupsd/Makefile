#
#-- Copyright (C) 2018 dz <dingzhong110@gmail.com>
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-cupsd
PKG_VERSION:=1.3

define Package/$(PKG_NAME)
LUCI_TITLE:=LuCI Support for cupsd
LUCI_PKGARCH:=all
LUCI_DEPENDS:=+luci-compat +kmod-usb-printer +kmod-usb-storage \
+cups +cups-bjnp +cups-bsd +cups-client +cups-filters +cups-ppdc
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
