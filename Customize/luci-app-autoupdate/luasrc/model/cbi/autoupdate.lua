require("luci.sys")
require("luci.util")
require("io")
local current_version = luci.sys.exec("cat /etc/openwrt_info | awk 'NR==1'")
local current_model = luci.sys.exec("egrep ARCH /etc/os-release | awk -F '[\"]' '{print $2}'")
local m, o
m=Map("autoupdate",translate("AutoUpdate"),translate("Scheduled Update is a timed run Openwrt-AutoUpdate application"))

s=m:section(TypedSection,"login","")
s.addremove=false
s.anonymous=true

o = s:option(Flag, "enable", translate("Enable AutoUpdate"),translate("启用后将在指定时间段自动检查并更新固件"))
o.default = 0
o.optional = false

o = s:option(Flag, "forceupdate", translate("Force Update"),translate("Do force upgrade"))
o.default = 0
o.optional = false

week=s:option(ListValue,"week",translate("xWeek Day"))
week:value(7,translate("Everyday"))
week:value(1,translate("Monday"))
week:value(2,translate("Tuesday"))
week:value(3,translate("Wednesday"))
week:value(4,translate("Thursday"))
week:value(5,translate("Friday"))
week:value(6,translate("Saturday"))
week:value(0,translate("Sunday"))
week.default=0

hour=s:option(Value,"hour",translate("xHour"))
hour.datatype = "range(0,23)"
hour.rmempty = false

pass=s:option(Value,"minute",translate("xMinute"))
pass.datatype = "range(0,59)"
pass.rmempty = false

luci.sys.call ( "sh /usr/share/autoupdate/Check_Update.sh > /dev/null")
local cloud_version = luci.sys.exec("cat /tmp/cloud_version")

button_upgrade_firmware = s:option (Button, "_button_upgrade_firmware", translate("Update Firmware"),
translatef("点击 执行升级 后请耐心等待至路由器重启.") .. "<br><br>设备名称:" ..current_model .. "<br>当前固件版本: " .. current_version .. "<br>云端固件版本: " .. cloud_version)
button_upgrade_firmware.inputtitle = translate ("Do Upgrade")
button_upgrade_firmware.write = function()
	luci.sys.call ("bash /bin/AutoUpdate.sh > /dev/null")
end

local e=luci.http.formvalue("cbi.apply")
if e then
  io.popen("/etc/init.d/autoupdate restart")
end

return m
