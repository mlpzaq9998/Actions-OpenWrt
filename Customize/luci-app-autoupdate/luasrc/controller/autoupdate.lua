module("luci.controller.autoupdate",package.seeall)

function index()
	entry({"admin","system","autoupdate"},cbi("autoupdate"),_("AutoUpdate"),1)
end
