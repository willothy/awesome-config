-- This uses NM.Device (https://lazka.github.io/pgi-docs/NM-1.0/classes/Device.html)
local nm = require('lgi').require('NM')

if nm.Client():get_devices() ~= nil then

    local nm_widget = require("modules.nm_widget")

    nm_widget({
        instant_update = true
    }):connect_signal("nm::update", function(_, access_point)
        awesome.emit_signal("signal::NetworkManager",
                            access_point.ssid,
                            access_point.strength)
    end)
end
